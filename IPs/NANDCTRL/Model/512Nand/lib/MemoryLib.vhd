--        ____________________________________ 
--       /                                    |
--      |                                     |
--      |      __________________   __________|
--      |     |                 |   |
--       \     \                |   |   _______________________________________________________
--        \     \               |   |
--         \     \              |   |                                                
--          \     \             |   |                                                NAND512W3A   
--           \     \            |   |      
--            \     \           |   |                                               512Gbit (x8)       
--             \     \          |   |                    528 Byte Page, 3V, NAND Flash Memories
--              \     \         |   |       
--               \     \        |   |                                     VHDL Behavioral Model
--                |     \       |   |                                               Version 1.0
--                |     |       |   |                                               
--  ______________|     |       |   |                     Copyright (c) 2005 STMicroelectronics
-- |                    |       |   |  
-- |                    |       |   |  _________________________________________________________
-- |___________________/        |___|
-- 
-- 
-- ********************************************************************************************* 
-- 
----------------------------------------------------------------------------------------
--                                    MEMORY LIST PACKAGE                             --
----------------------------------------------------------------------------------------
--                                                                                    --
--           Implements the memory array by a double list of memory cells.            --
--           Each cell is linked to the next cell and to the previous cell.           --
-- Is possible to acces to the head of the list, to the tail and also to the middle.  --
--                                                                                    -- 
----------------------------------------------------------------------------------------

library IEEE; 
   use IEEE.std_logic_1164.all;
   use IEEE.std_logic_TextIO.all;
   use IEEE.Std_Logic_Arith.all;

library Std;
   use STD.TextIO.all;

library Work;
   use work.Def.all;
   use work.Data.all;
   use work.StringLib.all;

package MemoryLib is

   type memory_cell;                                  -- the memory cell

   type cell_pointer is access memory_cell;           -- the pointer to the memory cell

   type memory_cell is record

        prev, nexto: cell_pointer;                    -- pointers to the previous cell and to the next cell
        value      : DataMem_type;                   
        endAddr    : AddrMem_Type;                 

   end record;

   type modality is (reading, writing, erasing);      -- reading the memory, writing in the memory or erasing the memory ?
   type balance  is (left, centre, right);            -- middle is balanced ?

   type memory_rec is record

        head, middle, tail: cell_pointer;
        bal_value: balance;

   end record;

   constant FF: DataMem_type:= (Others => '1');


   ------------------------------------------------------------------------
   -------  Public Procedures: they can be used in the model  -------------
   ------------------------------------------------------------------------

   -- Used to init the memory list
   procedure InitMemory(variable memory: inout memory_rec);    

   -- Used to write or to erase the memory
   procedure putMemory(variable memory: inout memory_rec; variable add: in AddrMem_type; variable data: in DataMem_type);

   -- Used to read a memory cell
   procedure getMemory(variable memory: in memory_rec; variable add: in AddrMem_type; variable data: out DataMem_type);

   -- Used to read a vector of memory cells
   procedure getMemoryBuffer(variable memory: in memory_rec; variable firstAdd: in AddrMem_type; variable numData: in natural; variable dataVector: out MemBuffer_type);
   
   -- Used to load a memory file in the memory list
   procedure LoadMemoryFile(FileName: in String; variable memory: inout memory_rec);

   -- Used to save into a file the memory list
   procedure SaveMemoryFile(FileName: in String; variable memory: in memory_rec);

   -- Used to display the memory list
   procedure PrintList(variable memory: in memory_rec);

   -- Used to display the two passed values
   procedure PrintData(variable add:in AddrMem_type; variable data: in DataMem_type);

   --------------------------------------------------------------------------
   ------  Private Procedures: they must be used only in this package  ------
   --------------------------------------------------------------------------
   
   -- Insert a cell to the head of the memory list
   procedure AddCellToHead(variable head: inout cell_pointer; variable add: in AddrMem_type; variable data: in DataMem_type; variable insdel_num: inout integer);

   -- Add a cell to the tail of the memory list
   procedure AddCellToTail(variable tail: inout cell_pointer; variable data: in DataMem_type; variable insdel_num: inout integer);

   -- Erase a cell of the memory list
   procedure EraseCell(variable memory: inout memory_rec; variable pointer: inout cell_pointer; variable insdel_num: inout integer);

   -- Erase the head of the memory list
   procedure EraseHead(variable head_pnt: inout cell_pointer; variable insdel_num: inout integer);

   -- Erase the tail of the memory list
   procedure EraseTail(variable tail: inout cell_pointer; variable insdel_num: inout integer);

   -- Insert a cell in the memory list
   procedure InsertCell(variable pointer: in cell_pointer; variable add: in AddrMem_type; variable data: in DataMem_type; variable insdel_num: inout integer);

   -- Return an error message when you try to write into a not empty cell
   procedure WriteError;

   -- Return an error message if the specified address is out of range
   procedure AddressError; 

   -- Update the position of the middle pointer of the memory list
   procedure UpdateMiddle(variable memory: inout memory_rec; variable add: in AddrMem_type; variable mode: in modality; variable insdel_num: inout integer);

   -- Search for the right position for a read or an update operation
   procedure SearchForRightPosition(variable middle: in cell_pointer; variable pnt: inout cell_pointer; variable next_pnt: out cell_pointer; variable add: in AddrMem_type; variable mode: in modality; variable writeError: out boolean);

end MemoryLib;


----------------------------------------------------------------
--------  Package Body - procedures implementation  ------------
----------------------------------------------------------------

package body MemoryLib is


   ------------------------------------------------
   -------  Initialization of the memory ----------
   ------------------------------------------------
   
   procedure InitMemory(variable memory: inout memory_rec) is
   variable pointer: cell_pointer;
   begin

     pointer:= new memory_cell;
     memory.head:= pointer;
     memory.middle:= pointer;                     -- pointer to the middle of the list
     memory.tail:= pointer;
     memory.bal_value:= centre;                   -- the memory is balanced

     pointer.value:= (others => '1');
     pointer.endAddr:= Last_Addr;

     pointer.prev:= null;
     pointer.nexto:= null;

   end;

   ----------------------------------------------------
   ---------  Print only a value of the list  ---------
   ----------------------------------------------------

   procedure PrintData(variable add: in AddrMem_type; variable data: in DataMem_type) is
   variable msg: line;
   begin

     write(msg, String'(" address =  "));
     write(msg, add);
     
     write(msg, String'("      "));

     write(msg, String'(" data =  "));
     write(msg, data);
     writeline(output, msg);

   end;


   ----------------------------------------------------
   ---------  Print the values of the list  -----------
   ----------------------------------------------------

   procedure PrintList(variable memory: in memory_rec) is
   variable pnt: cell_pointer;
   variable msg: line;
   begin

     pnt:= memory.head;
     while pnt /= null loop

        write(msg, pnt.value);
        write(msg, String'("  "));
        write(msg, pnt.endAddr);
        writeline(output,msg);
        
        pnt:= pnt.nexto;

     end loop;

     pnt:= memory.middle;

     write(msg, String'(" middle.value =  "));
     write(msg, pnt.value);
     write(msg, String'(" middle.endAddr =  "));
     write(msg, pnt.endAddr);
     write(msg, String'("    balance = "));
     
     if memory.bal_value = left then 
        write(msg, String'("left"));
     elsif memory.bal_value = centre then 
        write(msg, String'("centre"));
     else 
        write(msg, String'("right"));
     end if;
     
     writeline(output, msg);

   end;


   -----------------------------------------------------
   ----------  Searching in the memory list  -----------
   -----------------------------------------------------

   procedure SearchForRightPosition(variable middle: in cell_pointer; variable pnt: inout cell_pointer; variable next_pnt: out cell_pointer; variable add: in AddrMem_type; variable mode: in modality; variable writeError: out boolean) is
   variable search_pnt: cell_pointer;
   begin

     search_pnt:= middle;               -- searching starts from middle of the list
     pnt:= search_pnt;
     writeError:= false;

        if add < middle.endAddr then       -- search direction is left
     
           while add < search_pnt.endAddr
           
                 loop 
                        search_pnt:= search_pnt.prev;
                 end loop;
        
              if add > search_pnt.endAddr then 
       
                  if mode = writing then 
                        
                        pnt:= search_pnt.nexto;
                        next_pnt := pnt.nexto;

                  else 
                        pnt:= null;   -- mode = erasing or mode = reading; the cell is already to FF
                        next_pnt := search_pnt.nexto;
                     
                  end if;

                  writeError:= false;

               else        -- add = search_pnt.endAddr        
                  if mode = writing then 
               
                     if search_pnt.value = FF then 
                        search_pnt.endAddr:= search_pnt.endAddr - 1;
                        pnt:= search_pnt.nexto;
                        writeError:= false;

                     --elsif mode = reading then pnt:= search_pnt;         -- the value not is FF   
                        
                     else 
                          pnt:= search_pnt;
                          writeError:= true;             -- address is already written in the memory

                     end if;
                     
                   else                        -- mode = erasing or reading
                      pnt:= search_pnt;
                      writeError:= false;
                   end if;
               
                 next_pnt := pnt.nexto;

              end if;

        else                                 -- search direction is right 
     
          while add > search_pnt.endAddr 

              loop 
                  search_pnt:= search_pnt.nexto;
              end loop;

              if add < search_pnt.endAddr then              -- pnt:= search_pnt;

                 if mode = writing then 

                        pnt:= search_pnt;
                 else 
                        pnt:= null;   -- mode = erasing or mode = reading; the cell is already to FF
                     
                 end if;
                
                 next_pnt:= search_pnt;
                 writeError:= false;
            
              else   -- add = search_pnt.endAddr
             
                 if mode = writing then

                    if search_pnt.value = FF then 
                       search_pnt.endAddr:= search_pnt.endAddr - 1;
                       pnt:= search_pnt.nexto;

                    --elsif mode = reading then pnt:= search_pnt;   

                    else 
                        pnt:= search_pnt;
                        writeError:= true;      -- address is already written in the memory
                   
                    end if;
                   
                 else 
                     pnt:= search_pnt;   -- mode = erasing or reading
                     writeError:= false;

                 end if;
               
               next_pnt := search_pnt.nexto;
             end if;
       
        end if;

     -- In each case the right position is between pnt and pnt.prev

   end;


   ---------------------------------------------------------
   --------  Insert a cell in the memory list  -------------
   ---------------------------------------------------------

   procedure InsertCell(variable pointer: in cell_pointer; variable add: in AddrMem_type; variable data: in DataMem_type; variable insdel_num: inout integer) is
   variable ins_pnt, prev_pnt: cell_pointer;
   variable i: integer;
   variable myadd: AddrMem_type;
   variable mydata: DataMem_type;
   variable mypointer: cell_pointer;
   begin

      -- Insert the new two cells between pnt and pnt.prev

      myadd:= add;
      mydata:= data;
      mypointer:= pointer;
     
      for i in 1 to 2 loop
    
        ins_pnt:= new memory_cell;
        prev_pnt:= mypointer.prev;

        ins_pnt.value:= mydata;
        ins_pnt.endAddr:= myadd;

        ins_pnt.nexto:= mypointer;
        ins_pnt.prev:= prev_pnt;
        prev_pnt.nexto:= ins_pnt;
        mypointer.prev:= ins_pnt;

        if (i = 1) then 
           if (ins_pnt.endAddr - prev_pnt.endAddr = 1) then 
           
              insdel_num:= 1;
              exit;
              
           else 
              mypointer:= ins_pnt;
              ins_pnt:= null;
              mydata:= FF;
              myadd:= myadd - 1;
              insdel_num:= 2;
           end if;
        end if;   

      end loop;

   end;


   ---------------------------------------------------------------------
   --------  Insert a cell in the tail of the memory list  -------------
   ---------------------------------------------------------------------

   procedure AddCellToTail(variable tail: inout cell_pointer; variable data: in DataMem_type; variable insdel_num: inout integer) is
   variable pnt: cell_pointer;
   begin

        pnt:= new memory_cell;
        pnt.endAddr:= Last_Addr;
        pnt.value:= data;
        pnt.prev:= tail;
        tail.nexto:= pnt;

        tail:= pnt;
        insdel_num:= 1;

   end;

   ---------------------------------------------------------------
   ------------  Error Message during Add operation  -------------
   ---------------------------------------------------------------

   procedure AddressError is
   begin

      assert (false) report "The specified address is out of the memory range" severity note;

   end;


   ---------------------------------------------------------------
   -----------  Error Message in writing operation  --------------
   ---------------------------------------------------------------

   procedure WriteError is
   begin

     assert (false) report "The specified location is not empty. It is not possible writing on it." 
     severity note;

   end;

   ----------------------------------------------------------------
   -----------  Add a cell to the head of the memory list  --------
   ----------------------------------------------------------------

   procedure AddCellToHead(variable head: inout cell_pointer; variable add: in AddrMem_type; variable data: in DataMem_type; variable insdel_num: inout integer) is
   variable pnt_one, pnt_two: cell_pointer;
   begin
   
     pnt_one:= new memory_cell;
     pnt_one.endAddr:= add;
     pnt_one.value:= data;

     head.prev:= pnt_one;

     if add /= 0 then 
     
        pnt_two:= new memory_cell;
     
        pnt_one.prev:= pnt_two;
        pnt_two.prev:= null;

        pnt_two.nexto:= pnt_one;
        pnt_one.nexto:= head;

        head:= pnt_two;
        
        head.value:= FF;
        head.endAddr:= add - 1;

        insdel_num:= 2;

     else                        -- Write at the address 000000 

        pnt_one.prev:= null;
        pnt_one.nexto:= head;
        head:= pnt_one;

        insdel_num:= 1;

     end if;

   end;

   ---------------------------------------------------------------
   ---------  Read the data in a memory cell  --------------------
   ---------------------------------------------------------------

   procedure getMemory(variable memory: in memory_rec; variable add: in AddrMem_type; variable data: out DataMem_type) is
   variable pnt, pnt2, next_pnt: cell_pointer;
   variable read_mode: modality;
   variable writeError: boolean;
   begin

     pnt := memory.head;
     pnt2:= memory.tail;
     writeError:= false;

     if add < 0 or add > Last_addr then AddressError;
     
     elsif 
          add = pnt.endAddr then data:= pnt.value;

     elsif 
          add < pnt.endAddr then data:= FF;

     elsif 
          add = pnt2.endAddr then data:= pnt2.value;

     else    -- 0 < add < Last_Addr 

         read_mode:= reading;
         SearchForRightPosition(memory.middle, pnt, next_pnt, add, read_mode, writeError);
         if pnt /= null then data:= pnt.value;
         else data:= FF;
         end if;

     end if;    

   end;


   ---------------------------------------------------------------
   ---------  Read a vector of data in the memory ----------------
   ---------------------------------------------------------------

   procedure getMemoryBuffer(variable memory: in memory_rec; variable firstAdd: in AddrMem_type; variable numData: in natural; variable dataVector: out MemBuffer_type) is
   variable pnt, pnt2, firstData_pnt, nextData_pnt, current_pnt: cell_pointer;
   variable read_mode: modality;
   variable writeError: boolean;
   variable add : AddrMem_type;
   variable index : natural;
   begin

     pnt := memory.head;
     pnt2:= memory.tail;
     writeError:= false;
     nextData_pnt := null;

     if firstAdd < 0 or firstAdd > Last_addr then AddressError;

     --elsif firstAdd + numData > Memory_Dim - 1 then AddressError;

     elsif firstAdd = pnt.endAddr  then 
        
        firstData_pnt := pnt;
        nextData_pnt  := firstData_pnt.nexto;

     elsif firstAdd = pnt2.endAddr then 
        
        firstData_pnt := pnt2;
        nextData_pnt:= null;   -- pnt2 point to the tail

     elsif firstAdd < pnt.endAddr  then 
     
        firstData_pnt := null;
        nextData_pnt  := pnt;   -- head


     else    -- 0 < add < Last_Addr 

             read_mode:= reading;
             SearchForRightPosition(memory.middle, firstData_pnt, nextData_pnt, firstAdd, read_mode, writeError);

     end if;
        
     add := firstAdd;
     current_pnt:= firstData_pnt;
     
     for index in 1 to numData loop
        
        if current_pnt = null then 
        
                dataVector(index) := FF;
                        
        else    -- current_pnt /= null

                dataVector(index) := current_pnt.value;
        end if;
         
        if add + 1 > Memory_dim - 1 then 
                
                AddressError;
                exit;
        
        else 
                add := add + 1;
        
                if nextData_pnt = null then exit;
        
                elsif add < nextData_pnt.endAddr then current_pnt := null;
        
                elsif add = nextData_pnt.endAddr then 
        
                        current_pnt := nextData_pnt;
                        nextData_pnt := nextData_pnt.nexto;
              
                else exit;    -- add > nextData_pnt.endAddr => abbiamo finito !!!

                end if;
        end if;

     end loop;
    
   end;

  
   ---------------------------------------------------------------
   ------  Add or remove a cell to the memory list  --------------
   ---------------------------------------------------------------

   procedure putMemory(variable memory: inout memory_rec; variable add: in AddrMem_type; variable data: in DataMem_type) is
   variable pointer: cell_pointer;
   variable pnt, pnt2, nxpnt: cell_pointer;
   variable mode: modality;
   variable insdel_num: integer;
   variable writeError: boolean;             -- goes true if address is already in the list
   begin

     insdel_num:= 0;
     pnt := memory.head;
     pnt2:= memory.tail;
     writeError:= false;

     if (add > Last_Addr) or (add < 0) then AddressError;

     else            -- 0 <= add <= Last_Addr

        if data = FF then 
        
           mode:= erasing;

           -- if add < head.endAddr the cell is already to FF

           if  add = pnt.endAddr then 
           
                 if pnt.value /= FF then EraseHead(memory.head, insdel_num);
                 end if;
         
            elsif add = Last_Addr then EraseTail(memory.tail, insdel_num);
            
            elsif add > pnt.endAddr then       -- head.endAddr < add < Last_Addr 

               SearchForRightPosition(memory.middle, pointer, nxpnt, add, mode, writeError);
               if pointer /= null then EraseCell(memory, pointer, insdel_num);
               end if;

            end if;
        
        else                  -- data /= FF  =>   mode = writing 
        
             mode:= writing;
             --AddressInList(memory, add, addError);

             if  add = pnt.endAddr then 
                 if pnt.value /= FF then  pnt.value:= data;     --WriteError;         
                 else 
                     if add = 0 then pnt.value:= data; 
                     else    
                         pnt.endAddr:= pnt.endAddr - 1;
                         InsertCell(pnt.nexto, add, data, insdel_num);
                     end if;    
                 end if;
         
             elsif add < pnt.endAddr then AddCellToHead(memory.head, add, data, insdel_num); 

             elsif add = Last_addr then 

                if pnt2.value /= FF then  pnt2.value:= data;     --WriteError;         
                
                else 
                   pnt2.endAddr:= pnt2.endAddr - 1;
                   AddCellToTail(memory.tail, data, insdel_num);
                end if;   

             else         -- head.endAddr < add < Last_Addr 

               SearchForRightPosition(memory.middle, pointer, nxpnt, add, mode, writeError);
               if writeError then pointer.value:= data;   -- address is already written in the memory
               else
                   if pointer /= null then InsertCell(pointer, add, data, insdel_num);
                   end if;
               end if;    

             end if;

        end if;

        UpdateMiddle(memory, add, mode, insdel_num);         -- Update the pointer to the middle of the list

      end if;

   end;


   ---------------------------------------------------------------------
   ----------------  Erase a cell in the memory list  ------------------
   ---------------------------------------------------------------------

   procedure EraseCell(variable memory: inout memory_rec; variable pointer: inout cell_pointer; variable insdel_num: inout integer) is
   variable i: integer;
   variable prev_pnt, next_pnt, other_pnt: cell_pointer;
   begin

     -- erase the pointed cell and the previous cell only if its data is FF

     prev_pnt:= pointer.prev;
     next_pnt:= pointer.nexto;

     if (prev_pnt.value = FF) and (next_pnt.value = FF) then   -- remove prev and pointer 
       
        if (prev_pnt = memory.head) then

           next_pnt.prev:= null;
           pointer.nexto:= null;
           pointer.prev:= null;
           prev_pnt.nexto:= null;

           memory.head:= next_pnt;    -- change head
           if pointer = memory.middle then memory.middle:= next_pnt;
           end if;

        else        -- prev_pnt != head

           other_pnt:= prev_pnt.prev;
           other_pnt.nexto:= next_pnt;
           next_pnt.prev:= other_pnt;
           prev_pnt.prev:= null;
           prev_pnt.nexto:= null;
           pointer.nexto:= null;
           pointer.prev:= null;
        
        end if;

        deallocate(prev_pnt);
        deallocate(pointer);

        insdel_num:= 2;

     elsif (prev_pnt.value /= FF) and (next_pnt.value /= FF) then 
     
           pointer.value:= FF;
           insdel_num:= 0;

     else           -- prev_pnt.value /= FF or next_pnt.value /= FF but not both

        prev_pnt.nexto:= next_pnt;
        next_pnt.prev:= prev_pnt;

        pointer.prev:= null;
        pointer.nexto:= null;

        deallocate(pointer);

        insdel_num:= 1;

    end if;
        
   end;

   --------------------------------------------------------------------
   -------------  Remove the head of the list  ------------------------
   --------------------------------------------------------------------

   procedure EraseHead(variable head_pnt: inout cell_pointer; variable insdel_num: inout integer) is
   variable next_pnt: cell_pointer;
   begin

     next_pnt:= head_pnt.nexto;

     if next_pnt.value = FF then   -- remove head_pnt 

        next_pnt.prev:= null;
        head_pnt.nexto:= null;
        deallocate(head_pnt);
        head_pnt:= next_pnt;

        insdel_num:= 1;

     else           -- next_pnt.value /= FF 

        head_pnt.value:= FF;  

        insdel_num:= 0;
           
     end if;
        
   end;


   --------------------------------------------------------------------
   -------------  Remove the tail of the list  ------------------------
   --------------------------------------------------------------------

   procedure EraseTail(variable tail: inout cell_pointer; variable insdel_num: inout integer) is
   variable prev_pnt: cell_pointer;
   begin

     prev_pnt:= tail.prev;

     if prev_pnt.value = FF then   -- remove tail 

        prev_pnt.nexto:= null;
        tail.prev:= null;
        deallocate(tail);
        tail:= prev_pnt;
        tail.endAddr:= Last_Addr;

        insdel_num:= 1;

     else           -- prev_pnt.value /= FF 

        tail.value:= FF;  

        insdel_num:= 0;
           
     end if;
        
   end;


   ----------------------------------------------------------------------
   ------  Update the pointer to the middle of the memory list  ---------
   ----------------------------------------------------------------------

   procedure UpdateMiddle(variable memory: inout memory_rec; variable add: in AddrMem_type; variable mode: in modality; variable insdel_num: inout integer) is
   -- bal tell me if middle is not balanced, and on which side it stays 
   Variable pnt_middle: cell_pointer;
   Variable bal: balance;
   begin
   
     pnt_middle:= memory.middle;
     bal:= memory.bal_value;

     if mode = writing then 
     
        if add < pnt_middle.endAddr then
        
           if insdel_num = 2 then    -- two cells have been inserted 
              
              pnt_middle:= pnt_middle.prev;  -- bal not change here
              
           elsif insdel_num = 1 then   -- only a cell has been inserted 

               if bal = centre then bal:= right;
                  
               else
                  
                  if bal = right then 
                  
                       pnt_middle:= pnt_middle.prev;
                       bal:= centre;

                  else bal:= centre;    -- bal goes from left to centre

                  end if;
               
               end if;

           end if;
           
        elsif add > pnt_middle.endAddr then

              if insdel_num = 2 then    -- two cells have been inserted 
              
                 pnt_middle:= pnt_middle.nexto;  -- bal not change here
              
              elsif insdel_num = 1 then   -- only a cell has been inserted 

                   if bal = centre then bal:= left;
                  
                   else
                  
                       if bal = left then 
                       
                          pnt_middle:= pnt_middle.nexto;
                          bal:= centre;

                       else bal:= centre;    -- bal goes from left to centre

                       end if;
               
                   end if;

              end if;

        end if;

     else     -- mode = erasing

        if add < pnt_middle.endAddr then
        
           if insdel_num = 2 then    -- two cells have been deleted 
              
              if pnt_middle /= memory.tail then pnt_middle:= pnt_middle.nexto;  -- bal not change here
              end if;
              
           elsif insdel_num = 1 then   -- only a cell has been deleted 
               
               if bal = centre then bal:= left;
                  
               else
                  
                  if bal = left then
                  
                       pnt_middle:= pnt_middle.nexto;
                       bal:= centre;

                  else bal:= centre;    -- bal goes from right to centre

                  end if;
               
               end if;

           end if;
           
        elsif add > pnt_middle.endAddr then

              if insdel_num = 2 then    -- two cells have been deleted 
              
                 pnt_middle:= pnt_middle.prev;  -- bal not change here
              
              elsif insdel_num = 1 then   -- only a cell has been deleted 

                    if bal = centre then bal:= right;
                  
                    else
                  
                       if bal = right then
                       
                          pnt_middle:= pnt_middle.prev;
                          bal:= centre;

                       else bal:= centre;  -- bal goes from left to centre

                       end if;
               
                    end if;

              end if;

        end if;

     end if;

     memory.middle:= pnt_middle;
     memory.bal_value:= bal;

   end;


----------------------------------------------------------------------------
--------  Load the memory file in the memory list  -------------------------
----------------------------------------------------------------------------

procedure LoadMemoryFile(FileName: in String; variable memory: inout memory_rec) is

    file p_file : text open Read_Mode is FileName;
    variable l : line;
    variable ch : character;
    variable address : AddrMem_type;
    variable data : DataMem_type;
    variable index_addr : integer;
    variable index_data : integer;
    Constant dataHIGH : integer := data'high;
  begin

    InitMemory(memory);
    if (FileName/="")  then

       while not endfile (p_file) loop

            readline  (p_file,l);

            if (l'length>0) then

                address := 0;
                index_addr := AddrMem_Dim/4;
                if ((AddrMem_Dim rem 4) = 0) then
                   index_addr := index_addr - 1;
                end if;
                index_data := 0;
                read (l, ch);
  
                while (not(ch = '/')) loop  --- lettura e calcolo address
                        address := address + slv2int(char2quad_bits(ch))*(16**index_addr);
                        read (l, ch);
                        index_addr := index_addr - 1;
                end loop;
  
                read (l, ch);

                while (not(ch = ';')) loop  --- lettura dato
                  for i in 0 to 3 loop
                    data(DataBus_Dim - 1 - i - 4*index_data) := To_BitVector(char2quad_bits(ch))(3-i);
                   
                  end loop;
                  read (l, ch);
                  
                  index_data := index_data + 1;
                end loop;
                putMemory(memory, address, data);
            end if;  
  
       end loop;
    end if;
  end LoadMemoryFile;

  
------------------------------------------------------------------------------
-------------  Save the memory list into a memory file  ----------------------
------------------------------------------------------------------------------

procedure SaveMemoryFile(FileName: in String; variable memory: in memory_rec) is


    Constant NUMCHARHEXADDR :Integer := (AddrMem_Dim / 4) + ((AddrMem_Dim mod 4)+3)/4;
    Constant NUMCHARHEXDATA :Integer := (DataMem_Dim / 4);

    file p_file : text open Write_Mode is FileName;
    variable OutLine : line;
    Variable HexAddr : String(1 to NUMCHARHEXADDR);
    Variable HexData : String(1 to NUMCHARHEXDATA);
    Variable pnt: cell_pointer;
  begin

    if ((FileName/="")) then
      
          pnt:= memory.head;

          while pnt /= null loop

                      if (pnt.value /= FF) then
                                          HexAddr:=int2Hex(pnt.endAddr);
                                          HexData:=Int2Hexdata((slv2int(To_StdLogicVector(pnt.value))));
                                          Std.TextIO.Write(OutLine, HexAddr);
                                          Std.TextIO.Write(OutLine, '/');
                                          Std.TextIO.Write(OutLine, HexData);
                                          Std.TextIO.Write(OutLine, ';');
                                          Std.TextIO.WriteLine(p_file, OutLine);
                                          end if;
                              
                      pnt:= pnt.nexto;        
        end loop;

    end if;

  end SaveMemoryFile;


end MemoryLib;

