/**
 ****************************************************************************************************
 * @file        led.h
 * @author      正点原子Linux团队(ALIENTEK)
 * @version     V1.0
 * @date        2020-05-04
 * @brief       LED 驱动代码
 * @license     Copyright (c) 2020-2032, 广州市星翼电子科技有限公司
 ****************************************************************************************************
 * @attention
 *
 * 实验平台:正点原子 STM32MP1开发板
 * 在线视频:www.yuanzige.com
 * 技术论坛:www.openedv.com
 * 公司网址:www.alientek.com
 * 购买地址:openedv.taobao.com
 *
 * 修改说明
 * V1.0 20200504
 * 第一次发布
 *
 ****************************************************************************************************
 */

#ifndef __LED_H
#define __LED_H

#include "sys.h"

/* PI0引脚 定义 */
#define LED0_GPIO_PORT GPIOI
#define LED0_GPIO_PIN  GPIO_PIN_0
/* GPIOI时钟使能 */
#define LED0_GPIO_CLK_ENABLE()                                                                     \
	do {                                                                                       \
		__HAL_RCC_GPIOI_CLK_ENABLE();                                                      \
	} while (0)
/* PF3引脚 定义 */
#define LED1_GPIO_PORT GPIOF
#define LED1_GPIO_PIN  GPIO_PIN_3
/* GPIOF口时钟使能 */
#define LED1_GPIO_CLK_ENABLE()                                                                     \
	do {                                                                                       \
		__HAL_RCC_GPIOF_CLK_ENABLE();                                                      \
	} while (0)
/* LED0和LED1端口定义 */
#define LED0(x)                                                                                    \
	do {                                                                                       \
		x ? HAL_GPIO_WritePin(LED0_GPIO_PORT, LED0_GPIO_PIN, GPIO_PIN_SET)                 \
		  : HAL_GPIO_WritePin(LED0_GPIO_PORT, LED0_GPIO_PIN, GPIO_PIN_RESET);              \
	} while (0) /* LED0 = RED */
#define LED1(x)                                                                                    \
	do {                                                                                       \
		x ? HAL_GPIO_WritePin(LED1_GPIO_PORT, LED1_GPIO_PIN, GPIO_PIN_SET)                 \
		  : HAL_GPIO_WritePin(LED1_GPIO_PORT, LED1_GPIO_PIN, GPIO_PIN_RESET);              \
	} while (0) /* LED1 = GREEN */

/* LED取反定义 */
#define LED0_TOGGLE()                                                                              \
	do {                                                                                       \
		HAL_GPIO_TogglePin(LED0_GPIO_PORT, \ LED0_GPIO_PIN);                               \
	} while (0) /* LED0 = !LED0 */
#define LED1_TOGGLE()                                                                              \
	do {                                                                                       \
		HAL_GPIO_TogglePin(LED1_GPIO_PORT, \ LED1_GPIO_PIN);                               \
	} while (0) /* LED1 = !LED1 */

void led_init(void); /* 函数的声明，初始化 LED */

#endif
