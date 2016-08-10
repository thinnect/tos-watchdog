/**
 * Component for periodically reseting an external watchdog module attached to the UART TX pin.
 *
 * @author Raido Pahtma
 * @license MIT
*/
configuration PrintfTimerWatchdogC {
}
implementation {

	#warning "Are you sure you want to use this watchdog reset component?"

	components new PrintfTimerWatchdogP(PRINF_WATCHDOG_TOGGLE_PERIOD);

	components new TimerMilliC();
	PrintfTimerWatchdogP.Timer -> TimerMilliC;

	components MainC;
	PrintfTimerWatchdogP.Boot -> MainC;

}
