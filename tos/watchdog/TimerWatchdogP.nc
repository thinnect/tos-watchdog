/**
 * Component for periodically reseting the internal watchdog.
 *
 * @author Raido Pahtma
 * @license MIT
*/
#include <avr/wdt.h>
generic module TimerWatchdogP(uint32_t g_period_ms) {
	uses {
		interface Timer<TMilli>;
		interface Boot;
	}
}
implementation {

	#define __MODUUL__ "TWDT"
	#define __LOG_LEVEL__ ( LOG_LEVEL_TWDT & BASE_LOG_LEVEL )
	#include "log.h"

	uint32_t m_last_reset = 0;

	event void Timer.fired()
	{
		wdt_reset();
		debug1("%lu(%lu) wdt_reset", call Timer.getNow(), m_last_reset);
		m_last_reset = call Timer.getNow();
		call Timer.startOneShot(g_period_ms);
	}

	event void Boot.booted()
	{
		wdt_reset();
		m_last_reset = call Timer.getNow();
		call Timer.startOneShot(g_period_ms);
	}

}
