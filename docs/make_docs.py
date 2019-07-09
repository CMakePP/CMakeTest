import os
import subprocess


def strip_newline(block):
    """
    Strips any blank lines from the beginning and end of the block.
    :param block: The block to parse.
    :return: The block w/o the proceeding/trailing blank lines
    """
    start = 0
    end = len(block)
    for line in block:
        if line.strip():
            break
        start += 1

    # Early termination for empty block
    if start == end:
        return []

    for line in reversed(block[start:]):
        if line.strip():
            break
        end -= 1

    return block[start: end]


def write_code(block, lang):
    """
    Given a code block from the parsed file this function will turn it into the
    corresponding  reST code. This function will automatically remove any
    proceeding or trailing blank lines from the parsed code block.
    :param block: The code block to print out.
    :param lang: The language of the code snippet
    :return: A string suitable for printing in a reST file
    """
    a_tab = " "*4

    parsed_block = strip_newline(block)

    if len(parsed_block) == 0:
        return ""

    # Assemble the actual code block
    output = ".. code:: {}\n\n".format(lang)

    for line in parsed_block:
        output += a_tab + line
    output += '\n'

    return output


def write_comment(block):
    """
    This function takes the raw tutorial comment block and turns it into a
    string suitable for printing in a .rst file. This function does no
    processing of the block aside from removing  proceeding and trailing
    new lines
    :param block: The tutorial block comment to print out.
    :return: The comment-blcok reST-itized.
    """

    output = ""
    for line in strip_newline(block):
        output += line
    output += '\n'
    return output


def parse_file(cc, filename):
    """
    This function actually parses the test. It does so using some pretty simple
    logic. Consequentially, you can't deviate too much from the expected format.
    Specifically we assume:
     - The start of the tutorial block (i.e., "<comment_char>TUTORIAL") is the
       first non-whitespace token on the line.
     - The start of a skipping directive (i.e.,
       "<comment_char>TUTORIAL_START_SKIP") is the first non-whitespace token on
       the line.
     - The end of a skipping directive (i.e.,
       "<comment_char>TUTORIAL_STOP_SKIP") is the first non-whitespace token on
       the line.
       C++ is the first non-whitespace token on the line.
     - all comment blocks are continuous (no blank lines in the middle)
    :param cc: The character denoting the comment
    :param filename: The full path to the file
    :return: A list of tutorial comments and code blocks
    """

    # These are parsing strings we'll need to look for
    tutor_start = cc + "TUTORIAL"
    tutor_skip_start = cc + "TUTORIAL_START_SKIP"
    tutor_skip_stop = cc + "TUTORIAL_STOP_SKIP"

    comments = []  # Will be the comments we find
    code = []  # Will be the code snippets we fine
    in_comment = False  # True signals we are in a tutorial comment block
    skipping = False
    which_first = None

    with open(filename, 'r') as input_file:
        for line in input_file:
            no_ws = line.lstrip()  # The line w/o proceeding whitespace

            # Dispatch conditions
            is_skip_start = tutor_skip_start == no_ws[:len(tutor_skip_start)]
            is_skip_stop = tutor_skip_stop == no_ws[:len(tutor_skip_stop)]
            is_tutor_start = tutor_start == no_ws[:len(tutor_start)]
            is_comment = cc == line.lstrip()[:len(cc)]

            # Actually do the dispatching
            if skipping:  # Currently skipping
                if is_skip_stop:  # and we were told to stop
                    skipping = False
            elif is_skip_stop:  # Not skipping, but told to stop
                raise Exception("TUTORIAL_STOP_SKIP w/o TUTORIAL_START_SKIP")
            elif is_skip_start:  # Told to start skipping
                skipping = True
            elif is_tutor_start:  # Told to start tutorial comment
                if which_first is None:
                    which_first = True
                if in_comment:
                    raise Exception("Can't nest TUTORIAL sections")
                comments.append([])  # Start a new comment block
                in_comment = True
            elif is_comment and in_comment:  # Part of tutorial comment
                comments[-1].append(no_ws[len(cc):])  # omit comment character
            elif in_comment:  # 1st line outside a comment block
                in_comment = False
                code.append([])
                code[-1].append(line)
            else:  # n-th line outside a comment block
                if which_first is None:
                    which_first = False
                if len(code) == 0: # If code came first, there's no array yet
                    code.append([])
                code[-1].append(line)

    return comments, code, which_first


def write_tutorial(name, lang, comments, code, first):
    """
    Given the parsed comments and code blocks this function will write out the
    full reST page for the tutorial. It assumes that the code blocks and
    comment blocks are interspersed, i.e. the original file went
    code, comment, code, ...
    or
    comment, code, comment, ...
    Consequentially the number of code and comment blocks must be equal or can
    differ by at most one.
    :param name: The name of the tutorial. Will be used for the title.
    :param comments: A list of the comment blocks.
    :param code: A list of the code blocks.
    :param frist: True if a comment was first and false if a code block was
    :param lang: The language for the reST code snippets
    :return:
    """

    first_list = comments if first else code
    second_list = code if first else comments
    n_first = len(first_list)
    n_second = len(second_list)

    # The first list needs to be either the same size as the second or one more
    if n_first - n_second > 1:
        raise Exception("abs(#code blocks - #comment blocks) > 1")

    # Write the title of the tutorial
    output = name + '\n'
    output += '='*len(name) + "\n\n"

    for i in range(n_second):  # Loop over second because it is possibly shorter
        if first:
            output += write_comment(comments[i])
            output += write_code(code[i], lang)
        else:
            output += write_code(code[i], lang)
            output += write_comment(comments[i])

    if n_first == n_second + 1:
        if first:
            output += write_comment(comments[-1])
        else:
            output += write_code(code[-1], lang)

    return output


def write_index(file_names):
    output = "List of Tutorials\n" \
             "=================\n\n" \
             ".. toctree::\n" \
             "    :maxdepth: 2\n" \
             "    :caption: Contents:\n\n"
    for file_i in file_names:
        output += "    " + file_i + "\n"
    return output


def make_tutorials(input_dir, output_dir):
    """
    Given a full path to a directory, this function will parse each source file
    it finds. This process is repeated recursively for each subdirectory. For
    each tutorial file, a .rst file with the same name will be created which
    contains the contents of the source file converted to reST. The resulting
    tutorial will be named X, where X is the file name (without extension)
    converted to title case with underscores replace by spaces.
    :param input_dir: The full path to the directory containing the tutorials.
    :param output_dir: The full path to the directory where the tutorials should
                       go
    :return: nothing
    """

    # Define the comment characters and name for each language
    comment_chars = {".py": '#',
                     ".hpp": "//",
                     ".cpp": "//",
                     ".cmake": '#'}
    lang = {".py": "python",
            ".hpp": "c++",
            ".cpp": "c++",
            ".cmake": "cmake"}

    # Make output directory if it does not exist
    if not os.path.exists(output_dir):
        os.mkdir(output_dir)

    file_names = []  # Will be list of reST files we make

    for file_name in os.listdir(input_dir):
        input_file = os.path.join(input_dir, file_name)
        file_name_base, extension = os.path.splitext(file_name)

        if os.path.isdir(input_file):
            make_tutorials(input_file, os.path.join(output_dir, file_name))
            file_names.append(os.path.join(file_name, "index"))
            continue

        if extension not in lang:  # Not a file we're supposed to parse
            continue

        # Assemble the name of input file, output file, and tutorial

        output_file = os.path.join(output_dir, file_name_base + ".rst")
        tutorial_name = file_name_base.replace('_', ' ').title()

        file_names.append(file_name_base)

        rv = write_tutorial(tutorial_name, lang[extension],
                            *parse_file(comment_chars[extension], input_file))
        with open(output_file, 'w') as output_file:
            output_file.write(rv)


def main():
    docs_dir = os.path.dirname(os.path.realpath(__file__))
    root_dir = os.path.dirname(docs_dir)
    examples_dir = os.path.join(root_dir, "tests", "tutorials")
    tutorial_dir = os.path.join(docs_dir, "source", "tutorials")

    if not os.path.exists(tutorial_dir):
        os.mkdir(tutorial_dir)

    make_tutorials(examples_dir, tutorial_dir)
    subprocess.call(["make", "html"])


if __name__ == "__main__":
    main()
