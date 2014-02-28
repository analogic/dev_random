import 'package:unittest/unittest.dart';
import 'package:dev_random/dev_random.dart';

void main() {
  
  test("sync", () {
    var rnd = new DevRandom();
    
    expect(rnd.nextBool() is bool, isTrue);
    expect(rnd.nextInt(10) is int, isTrue);
  });
  
  test("async", () {
    var rnd = new DevRandom();
    
    var callback = expectAsync((var v) => expect(v is bool, isTrue));
    callback(rnd.nextBool());
    
    var callback1 = expectAsync((var v) => expect(v is int, isTrue));
    callback1(rnd.nextInt(10));
  });
  
  test("values", () {
    var rnd = new DevRandom();
    
    for(int i = 0; i < 100; i++) {
      expect(rnd.nextInt(100) < 100, isTrue);
      expect(rnd.nextInt(100) >= 0, isTrue);
    }
  });
  
  test("probability - can fail but highly unprobable :)", () {
    var rnd = new DevRandom();
    
    List<int> stats = new List.filled(10, 0);
    for(int i = 0; i < 100; i++) {
      stats[rnd.nextInt(10)]++;
    }
    
    stats.forEach((int count) => expect(count > 1, isTrue)); // every value 
    
    List<int> stats1 = new List.filled(2, 0);
    for(int i = 0; i < 100; i++) {
      rnd.nextBool() ? stats1[1]++ : stats1[0]++;
    }
    
    expect(stats1[0] > 35, isTrue);
    expect(stats1[1] > 35, isTrue);
  });
}