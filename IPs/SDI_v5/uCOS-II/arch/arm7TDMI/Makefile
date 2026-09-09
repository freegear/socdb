# pjk 050602

# load other configuration
include $(TOPDIR)/config.mk

LIB	= lib$(PORT).a
COBJECT = os_cpu_c.o
SOBJECT = os_cpu_a.o
START_UP = start_up.o

$(LIB):	$(COBJECT) $(SOBJECT) $(START_UP)
	$(AR) crv $@ $(COBJECT) $(SOBJECT)
.c.o :
	$(COMPILE) -c $<	
.S.o :
	$(COMPILE) -c $<
clean:
	rm -f $(COBJECT) $(SOBJECT) $(LIB) $(START_UP) .depend		

#########################################################################

.depend:	Makefile $(SOBJECT:.o=.S) $(COBJECT:.o=.c)
		$(CC) -M $(CPPFLAGS) $(SOBJECT:.o=.S) $(COBJECT:.o=.c) > $@

-include .depend

#########################################################################
		