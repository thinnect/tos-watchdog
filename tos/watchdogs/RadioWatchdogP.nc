/**
 * Reset watchdog based on radio start count.
 *
 * @author Raido Pahtma
 * @license MIT
 */
#include <avr/wdt.h>
module RadioWatchdogP {
	uses {
		interface TrafficMonitor;

		interface Timer<TMilli>;

		interface LocalTime<TMilli>;

		interface Boot;
	}
}
implementation {

	#define __MODUUL__ "RadioW"
	#define __LOG_LEVEL__ ( LOG_LEVEL_RadioW & BASE_LOG_LEVEL )
	#include "log.h"

	enum {
		WDT_RADIO_EXTEND_MAX_COUNT = 15,
		WDT_RADIO_PERIOD = 7168,
	};

	uint32_t radioStartCount = 0;
	uint8_t wdt_count = 0;

	event void Timer.fired() {
		if(call TrafficMonitor.getStartCount() != radioStartCount)
		{
			wdt_reset();
			wdt_count = 0;
			radioStartCount = call TrafficMonitor.getStartCount();
			logger(LOG_DEBUG2, "%lu WdtReset(rs=%lu)", call LocalTime.get(), radioStartCount);
		}
		else
		{
			if(wdt_count < WDT_RADIO_EXTEND_MAX_COUNT)
			{
				wdt_reset();
				wdt_count++;
			}
			logger(LOG_DEBUG2, "%lu WdtExtend(rs=%lu) %u", call LocalTime.get(), radioStartCount, wdt_count);
		}
	}

	event void Boot.booted() {
		wdt_reset();
		radioStartCount = call TrafficMonitor.getStartCount();
		call Timer.startPeriodic(WDT_RADIO_PERIOD);
	}

}
