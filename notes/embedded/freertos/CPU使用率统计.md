在 **FreeRTOS** 中，**CPU 使用率统计** 是衡量系统资源消耗、了解系统性能的一个重要手段。通过对 CPU 使用率的统计，可以帮助开发人员识别系统中是否存在性能瓶颈或任务调度不合理的问题。FreeRTOS 提供了一些机制和工具来实现 CPU 使用率的监控和统计。

### 1. **FreeRTOS 原生 CPU 使用率统计**

FreeRTOS 提供了一个 **系统空闲任务（idle task）** 的计时器，通过计算空闲任务的时间来间接推算出 CPU 的使用率。

#### 基本原理

- **空闲任务**：FreeRTOS 中的空闲任务是一个在系统中所有其他任务都处于阻塞状态时执行的任务。通过监控空闲任务的执行时间，可以间接得到 CPU 的使用情况。
- **CPU 使用率** = 1 - 空闲任务占用的比例

#### 使用方法

1. **启用 CPU 使用率统计**：
    FreeRTOS 内部通过 `configUSE_STATS_FORMATTING_FUNCTIONS` 和 `configGENERATE_RUN_TIME_STATS` 这两个宏来配置是否启用 CPU 使用率统计功能。

   在 `FreeRTOSConfig.h` 文件中，确保以下配置已启用：

   ```c
   #define configUSE_STATS_FORMATTING_FUNCTIONS 1        // 启用格式化函数
   #define configGENERATE_RUN_TIME_STATS 1               // 启用运行时统计功能
   ```

2. **配置计时器（Tick Hook）**：
    FreeRTOS 使用 **Tick Hook** 来周期性地进行任务切换和计时，确保统计数据的更新。可以通过 `vTaskGetRunTimeStats()` 函数来获取 CPU 使用率相关的统计信息。

3. **实现运行时统计**：
    在 `FreeRTOSConfig.h` 中，还需要定义 `configUSE_TICK_HOOK` 以确保有一个钩子函数来更新统计信息。

   ```c
   #define configUSE_TICK_HOOK 1  // 启用 Tick Hook
   ```

   然后，在你的应用程序中，可以定义一个钩子函数来计算 CPU 使用率：

   ```c
   void vApplicationTickHook(void)
   {
       // 在这里可以更新一些统计数据
   }
   ```

#### 获取 CPU 使用率

通过调用 `vTaskGetRunTimeStats()` 函数，可以获取各个任务的 CPU 使用率。`vTaskGetRunTimeStats()` 会输出每个任务的运行时间，基于这些数据，可以计算每个任务的 CPU 占用。

```c
void vApplicationIdleHook(void)
{
    static uint32_t lastIdleTime = 0;
    uint32_t idleTime;

    idleTime = xTaskGetTickCount() - lastIdleTime;
    lastIdleTime = xTaskGetTickCount();

    // 使用 idleTime 来计算 CPU 使用率
}
```

**注意**：计算空闲任务的时间差来估算 CPU 使用率时，需要确保任务的调度周期是稳定的。

### 2. **使用 FreeRTOS 内置统计工具**

FreeRTOS 提供了一个名为 **Run-Time Stats** 的功能，它是通过记录每个任务的运行时间来实现的。需要启用运行时统计和配置适当的定时器来完成。

#### 启用 Run-Time Stats 功能

1. **配置 `configUSE_RUN_TIME_STATS`**：
    在 `FreeRTOSConfig.h` 中启用运行时统计：

   ```c
   #define configUSE_RUN_TIME_STATS 1   // 启用运行时统计
   ```

2. **定义 `portGET_RUN_TIME_COUNTER_VALUE`**：
    运行时统计的计算基于系统计数器（如硬件定时器）。不同的硬件平台可能需要不同的实现。对于常见的 **Cortex-M** 系列处理器，通常使用 SysTick 计时器。

   ```c
   #define portGET_RUN_TIME_COUNTER_VALUE() (SysTick->VAL)  // 使用 SysTick 计时器
   ```

3. **配置 `configRUN_TIME_COUNTER`**：
    可以选择使用硬件定时器来作为运行时计数器。例如，如果使用定时器计数器作为系统的时钟，可以这样配置：

   ```c
   #define configRUN_TIME_COUNTER 1
   ```

4. **计算任务 CPU 使用率**：
    使用 `vTaskGetRunTimeStats()` 来计算和输出每个任务的 CPU 使用情况。该函数会返回一个字符数组，其中每个字符代表一个任务的运行时间。

   ```c
   char statsBuffer[1024];  // 存储任务统计信息
   vTaskGetRunTimeStats(statsBuffer);
   printf("Task Runtime Stats:\n");
   printf("%s\n", statsBuffer);
   ```

   该函数会输出每个任务的 CPU 占用时间，可以在调试输出中查看，或者通过调试工具直接查看。

### 3. **FreeRTOS 中的 CPU 使用率计算**

对于 **空闲任务** 以外的任务，CPU 使用率的计算公式如下：

```
CPU 使用率 = (总运行时间 - 空闲任务的运行时间) / 总运行时间
```

#### 运行时统计数据格式：

FreeRTOS 运行时统计会返回类似以下格式的输出：

```
TaskName     Time (ticks)   Percentage
-------------------------------------------------
Task1        1234           15%
Task2        2345           25%
Task3        3456           30%
Idle         4567           30%
-------------------------------------------------
Total        12345          100%
```

其中，`Time (ticks)` 表示任务的运行时间（单位为 tick），而 `Percentage` 表示任务的 CPU 占用率。

### 4. **使用外部工具进行 CPU 使用率统计**

除了 FreeRTOS 内置的统计方法，你还可以使用一些外部工具（如 **Segger SystemView**）来帮助分析系统的 CPU 使用情况。**SystemView** 是一个高级的 RTOS 监控工具，可以实时显示每个任务的状态，包括 CPU 使用率、任务切换时间等。通过与 FreeRTOS 集成，可以大大简化 CPU 使用率的统计和调试过程。

- **SystemView 集成**：
  - 安装并配置 SystemView，连接到 FreeRTOS。
  - 使用 SystemView 来分析任务调度和 CPU 使用率。

SystemView 提供了详细的任务视图，可以直观地查看 CPU 的使用情况，并生成报表。

### 5. **总结**

- **FreeRTOS 内置功能**：通过启用 `configGENERATE_RUN_TIME_STATS` 和 `configUSE_STATS_FORMATTING_FUNCTIONS`，可以通过 `vTaskGetRunTimeStats()` 函数获取每个任务的 CPU 使用率。
- **硬件计数器**：使用硬件定时器（如 SysTick）作为运行时计数器，可以更精确地计算每个任务的执行时间。
- **CPU 使用率公式**：通过计算总运行时间和空闲任务的时间差来推算 CPU 使用率。
- **外部工具（如 SystemView）**：使用工具来分析系统的 CPU 使用率，提供更直观的监控和分析。

使用这些方法，你可以有效地监控和优化 FreeRTOS 系统中的 CPU 使用率，帮助确保系统高效运行，避免资源浪费。