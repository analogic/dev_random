import 'dart:math';
import 'dart:io';
import 'dart:async';

/**
 * Thin wrapper for sync/async reading of /dev/(u)random with interface 
 * math.Random
 */
class DevRandom implements Random {
  String _filepath;
  File _source;
  
  /**
   * Creates random number generator. The optional parameter [filepath] is 
   * used for defining unix random source. Basicaly there are two options
   * on Linux system: 
   * /dev/random - truly random system source
   * /dev/urandom (default) - non-blocking source which reuses the internal 
   * pool to produce more pseudo-random bits
   */
  DevRandom([this._filepath = '/dev/urandom']) {
    _source = new File(_filepath);
  }
  
  /**
   * Generates a positive random integer uniformly distributed on the range
   * from 0, inclusive, to [max], exclusive.
   * 
   * Supports [max] values between 1 and ((1<<32) - 1) inclusive.
   */
  int nextInt(int max) => _convertToIntWithMax(_readBytesSync(4), max);
  
  /**
   * Generates asynchronously a positive random integer uniformly distributed 
   * on the range from 0, inclusive, to [max], exclusive.
   * 
   * Supports [max] values between 1 and ((1<<32) - 1) inclusive.
   */
  Future<int> nextIntAsync(int max) =>
      _readBytesAsync(4)
      .then((var bytes) => _convertToIntWithMax(bytes, max));
  
  /**
   * Generates a random boolean value.
   */
  bool nextBool() {
    List<int> l = _readBytesSync(1);
    return (l[0] & 1) == 0;
  }
  
  /**
   * Generates asynchronously a random boolean value.
   */
  Future<bool> nextBoolAsync() => 
      _readBytesAsync(1)
      .then((var bytes) => (bytes[0] & 1) == 0);
  
  /**
   * Not implemented yet
   */
  double nextDouble() => throw('Not implemented');
  
  /**
   * Not implemented yet
   */
  double nextDoubleAsync() => throw('Not implemented');

  List<int> _readBytesSync(int count) {
    var fd = _source.openSync(mode: FileMode.READ);
    List<int> result = fd.readSync(count);
    fd.close();
    return result;
  }
  
  Future<List<int>> _readBytesAsync(int count) {
    RandomAccessFile fd;
    List<int> data;
    
    return _source.open(mode: FileMode.READ)
    .then((fd) => fd.read(count))
    .then((data) => fd.close())
    .then((_) => data);
  }
  
  int _convertBytesToInt(List<int> bytes) => 
      bytes[0] << 24 | bytes[1] << 16 | bytes[2] << 8 | bytes[3];
  
  int _convertToIntWithMax(List<int> bytes, int max) =>
      (_convertBytesToInt(bytes) / ((1<<32) - 1) * max).truncate();
}