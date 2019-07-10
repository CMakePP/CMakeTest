include_guard()

## @fn _ct_comment_dispatch(line)
#  @brief Determines if the provided line is commented out.
#
#  While dispatching there is nothing to be done for lines that are purely
#  comments (*i.e.*, the first non-whitespace character is `#`). This function
#  will determine if the provided line is a comment. If the line is a comment
#  this function will return control from the calling function. Note that our
#  parser will get screwed-up if we consider comment lines and those lines
#  contain CMakeTest commands, which is why we must filter comments out.
#
#  @param[in] line The line we are examining for its comment-ness
macro(_ct_comment_dispatch _cd_line)
    # CMake's regex doesn't work well with spaces, so replace them with 'x'
    string(REPLACE " " "x" _cd_buffer "${_cd_line}")

    # Now if the line is "#" or "x#", or "xx#", etc. we know it's a comment line
    string(REGEX MATCH "^x*#" _cd_match "${_cd_buffer}")
    if(NOT "${_cd_match}" STREQUAL "")
        return()
    endif()
endmacro()
