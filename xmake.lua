local project_name = "Project"
local target_dir = "Build"
local download_cfg = "stlink.cfg"

-- 设置工程名
set_project("stm32mp157-generic")
-- 设置工程版本
set_version("1.0.0")

add_rules("mode.debug", "mode.release", "mode.releasedbg", "mode.minsizerel")
set_defaultmode("releasedbg")

set_plat("cross")
set_arch("cortex-m4")

-- 自定义工具链
toolchain("arm-none-linux-gnueabihf")
    -- 标记为独立工具链
    set_kind("standalone")
    -- 定义交叉编译工具链地址
    set_sdkdir("/usr/local/arm/bin/gcc-arm-9.2-2019.12-x86_64-arm-none-linux-gnueabihf")
    set_bindir("/usr/local/arm/bin/gcc-arm-9.2-2019.12-x86_64-arm-none-linux-gnueabihf/bin")
toolchain_end()

local cflags = {
	"-mcpu=cortex-m4",
	" -mthumb",
	"-mfloat-abi=hard  -mfpu=fpv4-sp-d16",
	"-fdata-sections -ffunction-sections",
	"-nostartfiles",
	"-Os",
}

local ldflags = {
	"-specs=nano.specs",
	"-lc",
	"-lm",
	"-lnosys",
	"-Wl,--gc-sections",
}

-- basic board info
target(project_name)
    local CPU = "-mcpu=cortex-m4"
    local FPU = "-mfpu=fpv4-sp-d16"
    local FLOAT_ABI = "-mfloat-abi=hard"
    local LDSCRIPT = "STM32F411RCTx_FLASH.ld"

    add_defines("USE_HAL_DRIVER", "STM32F411xE")
    add_cflags(CPU, "-mthumb", FPU, FLOAT_ABI, "-fdata-sections", "-ffunction-sections", {force = true})
    add_asflags(CPU, "-mthumb", FPU, FLOAT_ABI, "-fdata-sections", "-ffunction-sections", {force = true})
    add_ldflags(CPU, "-mthumb", FPU, FLOAT_ABI, "-specs=nano.specs", "-T"..LDSCRIPT, "-lm -lc -lnosys", "-Wl,-Map=" .. target_dir .. "/" .. project_name .. ".map,--cref -Wl,--gc-sections", {force = true})
    add_syslinks("m", "c", "nosys")
target_end()

-- other config
target(project_name)
    set_targetdir(target_dir)
    set_objectdir(target_dir .. "/obj")
    set_dependir(target_dir .. "/dep")
    set_kind("binary")
    set_extension(".elf")
    set_toolchains("arm-none-linux-gnueabihf")
    -- add_toolchains("arm-none-eabi")
    set_warnings("all")
    set_languages("c11", "cxx17")

    if is_mode("debug") then
        set_symbols("debug")
        add_cxflags("-Og", "-gdwarf-2", {force = true})
        add_asflags("-Og", "-gdwarf-2", {force = true})
    elseif is_mode("release") then
        set_symbols("hidden")
        set_optimize("fastest")
        set_strip("all")
    elseif is_mode("releasedbg") then
        set_optimize("fastes")
        set_symbols("debug")
        set_strip("all")
    elseif is_mode() then
        set_symbols("hidden")
        set_optimize("smallest")
        set_strip("all")
    end
target_end()

-- add files
target(project_name)
    -- add_files(
    --     "Drivers/CMSIS/Device/ST/STM32MP1xx/Source/Templates/*.c",
    --     "Drivers/CMSIS/Device/ST/STM32MP1xx/Source/Templates/gcc/startup_stm32mp15xx.s"
    -- )

    -- add_includedirs(
    --     "Drivers/CMSIS/Device/ST/STM32MP1xx/Include",
    --     "Drivers/CMSIS/Include"
    -- )
target_end()

includes("Drivers/BSP/xmake.lua")
includes("Drivers/CMSIS/xmake.lua")
includes("Drivers/STM32MP1xx_HAL_Driver/xmake.lua")
includes("Drivers/SYSTEM/xmake.lua")
includes("User/xmake.lua")

task("flash")
    on_run(
        function()
            print("**********************以下开始写入 stm32*******************")
            os.exec("st-info --probe")
            --虽然 16 进制文件不需要指定地址, 但是好像默认是需要的, 不过这个地址不影响
            os.exec("st-flash write ./build/output.hex 0x0800000")
            -- os.exec("st-flash write ./build/output.bin 0x0800000")
            print("******************如果上面没有 error, 则写入成功********************")
        end
    )
task_end()

task("flash")
    on_run(
        function()
            os.exec("openocd -f jlink.cfg -f stm32f4x.cfg -c 'program Build/TestProject.hex verify reset exit'")
        end
    )
    -- 设置插件的命令行选项
    set_menu {
        -- 设置菜单用法
        usage = "xmake flash",
        -- 设置菜单描述
        description = "Download the flash",
        -- 设置菜单选项，如果没有选项，可以设置为{}
        options ={}
    }
task_end()

target(project_name)
    set_kind("binary")
    set_toolchains("arm-none-linux-gnueabihf")
    add_files()
    add_includedirs()
    -- 启用所有警告
    set_warnings("all")
    add_defines(
        "CORE_CM4",
        "USE_HAL_DRIVER",
        "STM32MP157Dxx"
    )

    add_cflags(
        "-mcpu=cortex-m4",
        " -mthumb",
        "-mfloat-abi=hard  -mfpu=fpv4-sp-d16",
        "-fdata-sections -ffunction-sections",
        "-nostartfiles",
        "-Os",
        "-Wall -fdata-sections -ffunction-sections",
        "-g -gdwarf-2",{force = true}
    )

    add_asflags(
        "-Og",
        "-mcpu=cortex-m4",
        "-mthumb",
        "-x assembler-with-cpp",
        "-Wall -fdata-sections -ffunction-sections",
        "-g -gdwarf-2",{force = true}
    )

    add_ldflags(
        "-Og",
        "-mcpu=cortex-m4",
        "-L./",
        "-TSTM32F103C8Tx_FLASH.ld",
        "-Wl,--gc-sections",
        "-lc -lm -lnosys -lrdimon -u _printf_float",{force = true}
    )

    -- 设置编译文件的目录
    set_targetdir("Build")
    -- 设置生成的文件名称
    set_filename(project_name ..".elf")

    after_build(
        function(target)
            print("生成 HEX 和 BIN 文件")
            os.exec("arm-none-linux-gnueabihf-objcopy -O ihex ./build//output.elf ./build//output.hex")
            os.exec("arm-none-linux-gnueabihf-objcopy -O binary ./build//output.elf ./build//output.bin")
            print("生成已完成")
            import("core.project.task")
            -- task.run("flash")
            print("********************储存空间占用情况*****************************")
            os.exec("arm-none-linux-gnueabihf-size -Ax ./build/output.elf")
            os.exec("arm-none-linux-gnueabihf-size -Bx ./build/output.elf")
            os.exec("arm-none-linux-gnueabihf-size -Bd ./build/output.elf")
            print("heap-堆, stck-栈, .data-已初始化的变量全局/静态变量, bss-未初始化的 data, .text-代码和常量")
        end
    )
