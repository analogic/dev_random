dev_random
==========

Thin Dart wrapper for sync/async reading of /dev/(u)random with interface math.Random. (Only for Dart VM)

Todo
----
- implement nextDouble

Usage
-----

```Dart
	import 'package:dev_random/dev_random.dart';
	
  var r = new DevRandom();  // default "/dev/urandom"
  
  print(r.nextInt(5));      // blocking
  
  t.nextIntAsync(5).then((int r) => print(r)); // async
  
  print(r.nextBool() ? 'yes' : 'no'); // blocking
  
  r.nextBoolAsync().then((bool r) => print(r ? 'yes' : 'no')); // async 
	
```
