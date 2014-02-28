dev_random
==========

Thin Dart wrapper for sync/async reading of /dev/(u)random with interface math.Random (Only for Dart VM).

Todo
----
- implement nextDouble

Usage
-----

You should always use asynchronous methods, especialy with linux /dev/random which is very slow.

```Dart
	import 'package:dev_random/dev_random.dart';
	
  var r = new DevRandom();  // default "/dev/urandom"
  
  print(r.nextInt(5));      // blocking
  
  t.nextIntAsync(5).then((int r) => print(r)); // async
  
  print(r.nextBool() ? 'yes' : 'no'); // blocking
  
  r.nextBoolAsync().then((bool r) => print(r ? 'yes' : 'no')); // async 
	
	r.nextString(10); // generate random string length 10
	r.nextStringAsync(10).then((String s) => print(s)); // async

  r.nextStringAsync(10, DevRandom.ALPHA); // lowercase + uppercase
  r.nextStringAsync(10, DevRandom.ALPHA_LOWERCASE); // lowercase only
  r.nextStringAsync(10, DevRandom.ALPHANUM); // lowercase + uppercase + num
  r.nextStringAsync(10, DevRandom.ALL); // lowercase + uppercase + num + special chars
```
