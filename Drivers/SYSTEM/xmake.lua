target(g_project_name)
    add_files(
        "sys/*.c",
        "delay/*.c"
    )

    add_includedirs(
        "sys",
        "delay"
    )
target_end()
