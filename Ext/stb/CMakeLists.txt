project(stb)

add_library(${PROJECT_NAME} INTERFACE
    stb_image.h
    stb_image_resize.h
    )

target_include_directories(${PROJECT_NAME} INTERFACE ${CMAKE_CURRENT_SOURCE_DIR})
target_compile_definitions(${PROJECT_NAME} INTERFACE
    STB_IMAGE_IMPLEMENTATION
    STB_IMAGE_RESIZE_IMPLEMENTATION
)
