/**
 * Reset watchdog based on radio start count.
 * @author Raido Pahtma
 */
configuration RadioWatchdogC {
}
implementation {

	components RadioWatchdogP;

#if defined(PLATFORM_IRIS)
	components RF230RadioC as Radio;
#elif defined(PLATFORM_DENODE)
	components RFA1RadioC as Radio;
#else
	components ActiveMessageC as Radio;
#endif
	RadioWatchdogP.TrafficMonitor -> Radio;

	components new TimerMilliC();
	RadioWatchdogP.Timer -> TimerMilliC;

	components LocalTimeMilliC;
	RadioWatchdogP.LocalTime -> LocalTimeMilliC;

	components MainC;
	RadioWatchdogP.Boot -> MainC;

}
