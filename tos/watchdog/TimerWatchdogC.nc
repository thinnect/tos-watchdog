/**
 * Component for periodically reseting the internal watchdog.
 * @author Raido Pahtma
*/
generic configuration TimerWatchdogC(uint32_t g_period_ms) {
}
implementation {

	#warning "Are you sure you want to use this watchdog reset component?"

	components new TimerWatchdogP(g_period_ms);

	components new TimerMilliC();
	TimerWatchdogP.Timer -> TimerMilliC;

	components MainC;
	TimerWatchdogP.Boot -> MainC;

}
