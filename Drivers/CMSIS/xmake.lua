target(project_name)
    add_files(
        "Device/ST/STM32MP1xx/Source/Templates/gcc/startup_stm32mp15xx.s"
    )

    add_includedirs(
        "Include"
    )
target_end()
