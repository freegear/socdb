# pjk 050602

# load other configuration
include $(TOPDIR)/config.mk

LIB	= lib$(APP).a
COBJECT = serial.o stdio.o main.o
SOBJECT = 

$(LIB):	$(COBJECT) $(SOBJECT)
	$(AR) crv $@ $(COBJECT) $(SOBJECT)

.c.o :
	$(COMPILE) -c $<	
.S.o :
	$(COMPILE) -c $<	
clean:
	rm -f $(COBJECT) $(SOBJECT) $(LIB) .depend		

#########################################################################

.depend:	Makefile $(SOBJECT:.o=.S) $(COBJECT:.o=.c)
		$(CC) -M $(CPPFLAGS) $(SOBJECT:.o=.S) $(COBJECT:.o=.c) > $@

sinclude .depend

#########################################################################
				