Deploy script
=============

Normal state
------------

In the application root directory we have:

- APPLICATION: A link of "APPLICATION.current";
- APPLICATION.current: The current code;
- APPLICATION.oldest: A copy of the oldest code.

Syncronization
--------------

Process:

1. Copy the "APPLICATION.current" to "APPLICATION.newest";
3. Syncronize "APPLICATION.newest";
3. Copy "APPLICATION.current" to "APPLICATION.backup";
4. Replace link of "APPLICATION" to "APPLICATION.backup";
5. Remove "APPLICATION.oldest";
6. Move "APPLICATION.current" to "APPLICATION.oldest";
7. Move "APPLICATION.newest" to "APPLICATION.current".

In the application root directory now we have:

- APPLICATION.backup: A copy of the current code;
- APPLICATION: A link of "APPLICATION.backup";
- APPLICATION.current: The new code;
- APPLICATION.oldest: The current code.

Deploy
------

1. Replace link of "APPLICATION" to "APPLICATION.current";

Cleanup
-------

1. Remove "APPLICATION.backup";

In the application root directory now we have:

- APPLICATION: A link of "APPLICATION.current";
- APPLICATION.current: The current code;
- APPLICATION.oldest: A copy of the oldest code.

