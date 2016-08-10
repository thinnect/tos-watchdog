/**
 * Component for periodically reseting an external watchdog module attached to the UART TX pin.
 *
 * @author Raido Pahtma
 * @license MIT
*/
#include <avr/wdt.h>
generic module PrintfTimerWatchdogP(uint32_t g_period) {
	uses {
		interface Timer<TMilli>;
		interface Boot;
	}
}
implementation {

	#define __MODUUL__ "PWDT"
	#define __LOG_LEVEL__ ( LOG_LEVEL_PWDT & BASE_LOG_LEVEL )
	#include "log.h"

	#if (LOG_LEVEL_PWDT & LOG_DEBUG1) == 0
	#error "Must define LOG_LEVEL_PWDT LOG_DEBUG1 to use this component!"
	#endif

	uint32_t m_last_reset = 0;

	event void Timer.fired()
	{
		wdt_reset();
		debug1("%lu(%lu) watchdog", call Timer.getNow(), m_last_reset);
		m_last_reset = call Timer.getNow();
		call Timer.startOneShot(g_period);
	}

	event void Boot.booted()
	{
		m_last_reset = call Timer.getNow();
		call Timer.startOneShot(g_period);
	}

}
