/* timer related ruotins & defins */
#if !defined(TIMER_H)
#define TIMER_H
#define TICKS_PER_CLK	1 
#define TICKS_PER_SEC   CLK_FREQ/TICKS_PER_CLK

void set_timer_reload_value(int);
void timer_count_start();
int  timer_get_counter();

#endif
