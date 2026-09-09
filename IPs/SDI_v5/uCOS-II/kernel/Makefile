# pjk 050602

# load other configuration
include $(TOPDIR)/config.mk

LIB	= lib$(UCOS).a
#COBJECT = ucos_ii.o
COBJECT = os_core.o os_flag.o os_mbox.o os_mem.o os_mutex.o os_q.o os_sem.o os_task.o os_time.o

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
				