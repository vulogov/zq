# *CheetahTemplate* module

The module *CheetahTemplate* is exposed to the ZQL as *CT*. This module implementing conversion between data structures available to the ZQL to the formatted texts, using powerfull [Cheetah Template](https://pythonhosted.org/Cheetah/) language.

## About Cheetah Template language

I will not cover Cheetah Templating language by me-self. Instead, I will redirect you to the several documents provided by language authors:
  1. [Introduction](https://pythonhosted.org/Cheetah/users_guide/intro.html). Start here if you never been exposed to Cheetah before. Please spend few minutes browsing this document. Cheetah isn't Jinja or ASP or any other templating language you've may be exposed in the past.
  2. [Brief overview](https://pythonhosted.org/Cheetah/users_guide/language.html) of the Cheetah Templating language. Bit more than the Intro, bit less than full documentation. Good second step.

And again, if you are planningto us this module, please make sure that you've [read](https://pythonhosted.org/Cheetah/) standard Cheetah Template Documentation. 

## Exposed words

### Template({reference})

This is a "border crossing" word, just like 'ol trusty _(Out)_. "Border crossing" words are accepting "pipeline parameter" of one type and return value of another data type, down to the ZQL pipeline. The (CT.Template ...) word will expect context *"in"*, then it will pull the element from the Stack (if any), pass the data structure to the Template generator and will return formatted output from the generator *"out"*. Again, just like (Out).

Format of the call for the word (CT.Template) is

    (CT.Template {reference to the template file})

Reference to the template file do have the following format:

  1. *{string}* - content of the string will be passed as the value. So, if you want to create "in-line" templates, just pass them to the (CT.template ...)
  2. *+{string}* - content of the string wil be treated as a relative or full path to the file on the local filesystem, containing the Cheetah Template.
  3. *@{string}* - content of the string wil be treated as URL. ZQL processor will try to retrieve the data refered by this URL and this data will be used as Template.

(CT.Template...) returning the data, rendered with the template.

## Examples

