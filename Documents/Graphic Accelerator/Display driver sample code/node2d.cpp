//
// Copyright (c) Microsoft Corporation.  All rights reserved.
//
//
// Use of this source code is subject to the terms of the Microsoft end-user
// license agreement (EULA) under which you licensed this SOFTWARE PRODUCT.
// If you did not accept the terms of the EULA, you are not authorized to use
// this source code. For a copy of the EULA, please see the LICENSE.RTF on your
// install media.
//
/*


*/
#define DDI 1
#include <windows.h>
#include <winddi.h>
#include <gpe.h>
#include <memory.h>
#include <wingdi.h>


Node2D::Node2D(
    int width,
    int height,
    int x,
    int y,
    int align,            // = 4
    Node2D *pParent )    // = NULL
{
    DEBUGMSG(GPE_ZONE_CREATE,(TEXT("Creating initial Node2d which is %d x %d\r\n"), width, height ));
    m_nX = x;
    m_nY = y;
    m_nWidth = width;
    m_nHeight = height;
    m_nAlign = align;
    m_pParent = pParent;
    m_pChild1 = (Node2D *)NULL;
    m_pChild2 = (Node2D *)NULL;
    m_pSystemMem = (unsigned char *)NULL;
}
               
void Node2D::GetClosest( int width, int height, int *pLeastWaste, Node2D **ppBestFit )
{
    if( m_nWidth < width || m_nHeight < height )
        return; // this one (and any children) are too small
    if( m_pChild2 ) // This is a parent node, just check child nodes for better fit
    {
        m_pChild1->GetClosest( width, height, pLeastWaste, ppBestFit );
        m_pChild2->GetClosest( width, height, pLeastWaste, ppBestFit );
    }
    else if( !m_pChild1 )
    {
        // This node is free & big enough - check for fit
        int waste = m_nWidth * m_nHeight - width * height;
        if( *ppBestFit == (Node2D *)NULL || waste < *pLeastWaste )
        {
            *pLeastWaste = waste;
            *ppBestFit = this;
        }
    }
    // else, this node is in use
}

Node2D * Node2D::Split( int width, int height )
{
    DEBUGMSG(GPE_ZONE_CREATE,(TEXT("Splitting Node2d (%dx%d) to give %dx%d space\r\n"),
        m_nWidth, m_nHeight, width, height ));
    if ( height < m_nHeight )
    {
        // Split into top & bottom pieces - the top part will be further cut down to the correct width
        m_pChild1 = new Node2D( m_nWidth, height, m_nX, m_nY, m_nAlign, this );
        m_pChild2 = new Node2D( m_nWidth, m_nHeight-height, m_nX, m_nY+height, m_nAlign, this );

        if (m_pChild1)
        {
            return m_pChild1->Split( width, height );
        }
        else
        {
            return NULL;
        }
    }
    else if( width < m_nWidth )
    {
        // Split into left & right pieces
        m_pChild1 = new Node2D( width, m_nHeight, m_nX, m_nY, m_nAlign, this );
        m_pChild2 = new Node2D( m_nWidth-width, m_nHeight, m_nX+width, m_nY, m_nAlign, this );
        return m_pChild1;
    }

    return this;
}

long totalVideoMemUsed = 0;

Node2D * Node2D::Alloc( int width, int height )
{
    Node2D *pNode = (Node2D *)NULL;
    int waste;
    width = ( width + m_nAlign - 1 ) & ( - m_nAlign );    // Round up to alignment
    // Find the best node to contain the new area
    DEBUGMSG(GPE_ZONE_CREATE,(TEXT("Attempting to allocate %dx%d space\r\n"), width, height ));
    GetClosest( width, height, &waste, &pNode );
    if( pNode )
    {
        // Split the node into the required space & remainder piece(s)
        pNode = pNode->Split( width, height );
        DEBUGMSG(GPE_ZONE_CREATE, (TEXT("Succesfully allocated %dx%d at x=%d,y=%d\r\n"),
            pNode->m_nWidth, pNode->m_nHeight, pNode->m_nX, pNode->m_nY ));
        pNode->m_pChild1 = (Node2D *)(-1);
        totalVideoMemUsed += ((m_nWidth / m_nAlign ) * 4) * m_nHeight;
    }
    else
    {
        DEBUGMSG(GPE_ZONE_CREATE,(TEXT("Failed to allocate Node2d !!\r\n")));
    }
    return pNode;
}

void Node2D::Free()
{
    DEBUGMSG(GPE_ZONE_CREATE,(TEXT("Freeing %dx%d at x=%d,y=%d\r\n"),
        m_nWidth, m_nHeight, m_nX, m_nY ));

    if( m_pChild2 )
    {
        // We are being told to delete both child nodes as they are now free
        delete m_pChild1;
        delete m_pChild2;
        m_pChild1 = m_pChild2 = (Node2D *)NULL;
    }
    else
    {
        // m_pChild2 already is NULL, this Node was completely used by a surfobj
        if (m_pChild1 != (Node2D *)(-1))
            DEBUGMSG(1, (TEXT("Error: node is not associated with video memory!!! \r\n")));
        else 
            totalVideoMemUsed -= ((m_nWidth / m_nAlign ) * 4) * m_nHeight;
        m_pChild1 = (Node2D *)NULL;
        
    }
    if( m_pParent )
    {
        if( m_pParent->m_pChild1->m_pChild1 == m_pParent->m_pChild2->m_pChild1 )
        {
            // Now this & sibling are free so we can erase both & coalesce
            m_pParent->Free();
        }
    }
}

unsigned long Node2D::AvailSpace()
{
    if( m_pChild2 )
        return m_pChild1->AvailSpace()+m_pChild2->AvailSpace();
    else if( m_pChild1 != (Node2D *)NULL )
        return 0;
    else
        return m_nWidth * m_nHeight;
}


long totalMemNeeded = 0;
long  totalVideoMemPiece = 0;
long  totalVideoMemAlloc = 0;


int Node2D::SaveSurfToSystemMem(unsigned char *pVideoOrig, int stride)
{
    if (m_pChild2)
    {
        m_pChild1->SaveSurfToSystemMem(pVideoOrig,stride);
        m_pChild2->SaveSurfToSystemMem(pVideoOrig,stride);
        
    }
    else 
    {
        if (m_pChild1 == (Node2D *)(-1))  // this node is in use
        {
            ASSERT(m_nAlign != 0); // every piece of memory should be aligned

            totalVideoMemPiece ++;
 
            int bytesPerRow = (m_nWidth / m_nAlign) << 2; 
            m_pSystemMem = (unsigned char *)LocalAlloc(LMEM_FIXED, bytesPerRow * m_nHeight);
            if (m_pSystemMem)
            {    unsigned char *pRowStart = pVideoOrig + m_nY * stride + ((m_nX / m_nAlign) << 2);
                unsigned char *pSysMem = m_pSystemMem;
                
                for (int i=0; i < m_nHeight; i ++)
                {
                    memcpy( pSysMem, pRowStart, bytesPerRow);
                    pSysMem += bytesPerRow;
                    pRowStart += stride;
                }
                
                totalMemNeeded += bytesPerRow * m_nHeight;
                totalVideoMemAlloc ++;

            }
        }
    }
    return 0;
}

int Node2D::RestoreSystemMemtoSurf(unsigned char *pVideoOrig, int stride)
{
    if (m_pSystemMem)
    {
        int bytesPerRow = (m_nWidth / m_nAlign) << 2; 
        unsigned char *pRowStart = pVideoOrig + m_nY * stride + ((m_nX / m_nAlign) << 2);
        unsigned char *pSysMem = m_pSystemMem;
        
        for (int i=0; i < m_nHeight; i ++)
        {
            memcpy( pRowStart, pSysMem, bytesPerRow);
            pSysMem += bytesPerRow;
            pRowStart += stride;
        }
        LocalFree(m_pSystemMem);
        m_pSystemMem = NULL;
        return 0;
    }
    else if (m_pChild2)
    {
        return ( m_pChild1->RestoreSystemMemtoSurf(pVideoOrig,stride) &
        m_pChild2->RestoreSystemMemtoSurf(pVideoOrig, stride));
    }
    else if (m_pChild1)
    {
        return m_pChild1->RestoreSystemMemtoSurf(pVideoOrig, stride);
    }

    return 0;
}
