import 'dart:math';
import 'dart:io';
import 'dart:async';

class DevRandom implements Random {
  String _filepath;
  File _source;
  
  DevRandom([this._filepath = '/dev/urandom']) {
    _source = new File(_filepath);
  }
  
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
  
  int nextInt(int max) => _convertToIntWithMax(_readBytesSync(4), max);
  
  Future<int> nextIntAsync(int max) =>
      _readBytesAsync(4)
      .then((var bytes) => _convertToIntWithMax(bytes, max));
  
  bool nextBool() {
    List<int> l = _readBytesSync(1);
    return (l[0] & 1) == 0;
  }
  
  Future<bool> nextBoolAsync() => 
      _readBytesAsync(1)
      .then((var bytes) => (bytes[0] & 1) == 0);
  
  double nextDouble() => throw('Not implemented');
  double nextDoubleAsync() => throw('Not implemented');
}