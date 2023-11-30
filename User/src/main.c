/* Includes ------------------------------------------------------------------*/
#include "led.h"
#include "sys.h"
#include "delay.h"

int main(void)
{
	HAL_Init(); /* 初始化HAL库 */
	led_init(); /* 初始化LED  */

	while (1) {
		LED0(0);    /* 打开LED0 */
		delay(5000); /* 延时一段时间 */
		LED0(1);    /* 关闭LED0 */
		delay(5000); /* 延时一段时间 */
	}
}
