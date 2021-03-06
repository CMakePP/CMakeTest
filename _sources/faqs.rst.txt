Frequently Asked Questions (FAQs)
=================================

1. Why does ``ct_assert_prints`` fail to find a string that is present?

   - Are you sure it's present in the output **EXACTLY** as your search string?
     For better or for worse, CMake's ``message`` command does some formatting
     on strings before printing them (*e.g*, inserts two spaces after a period).
     Furthermore, it can be a real pain to match printed strings with line
     breaks in them. It is highly recommended that you search for a key phrase
     rather than the entire print-out.

2. Why does ``ct_assert_fails_as`` fail to find a string that is present?

   - See previous question.
