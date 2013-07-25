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

1. Copy "APPLICATION.current" to "APPLICATION.backup";
2. Replace link of "APPLICATION" to "APPLICATION.backup";
3. Move "APPLICATION.current" to "APPLICATION.newest";
4. Move "APPLICATION.oldest" to "APPLICATION.current".

In the application root directory now we have:

- APPLICATION.backup: A copy of the current code;
- APPLICATION: A link of "APPLICATION.backup";
- APPLICATION.current: The oldest code;
- APPLICATION.newest: The current code.

Deploy
------

1. Replace link of "APPLICATION" to "APPLICATION.current";

Cleanup
-------

1. Remove "APPLICATION.backup";

In the application root directory now we have:

- APPLICATION: A link of "APPLICATION.current";
- APPLICATION.current: The current code;
- APPLICATION.newest: A copy of the rollbacked code.

