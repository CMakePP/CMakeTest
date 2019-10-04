include_guard()
#[[[ Determines if the provided line is commented out.
#
# While parsing the contents of the unit test CMakeTest has nothing to do if
# the lines that are purely comments (*i.e.*, the first non-whitespace character
# is `#`). This function will determine if the provided line is a comment. If
# the line is a comment this function will return control from the calling
# function (assumed to be ``_parse_dispatch``). If the line is not a comment
# then this function will do nothing. At the moment our parser will get
# screwed-up if we consider comment lines and those lines contain CMakeTest
# commands, which is why we must filter comments out.
#
# .. note:
#
#    This function is a macro as it is inteded to be used as a logical
#    factorization inside parse_dispatch and we don't want parse_dispatch
#    to have to act on the results of this function. Since it is a macro, if it
#    calls ``return()`` it actually will return from ``_ct_parse_dispatch()``
#
# .. todo::
#
#    This function currently does not worry about block comments and needs
#    adjusted to account for this.
#
# :param _cd_line: The line we are examining for its comment-ness
# :type _cd_line: str
#]]
macro(_ct_comment_dispatch _cd_line)
    # CMake's regex doesn't work well with spaces, so replace them with 'x'
    string(REPLACE " " "x" _cd_buffer "${_cd_line}")

    # Now if the line is "#" or "x#", or "xx#", etc. we know it's a comment line
    string(REGEX MATCH "^x*#" _cd_match "${_cd_buffer}")
    if(NOT "${_cd_match}" STREQUAL "")
        return()
    endif()
endmacro()
