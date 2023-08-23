[Setting drag min=5 max=50]
uint64 MAX_FRAMETIME = 1;

[Setting drag min=1000 max=100000]
int MAX_FIB = 1000;

uint64 lastFrameTime = Time::Now;
uint64 startTime = Time::Now;
int num_yields = 0;

array<FibObj@>@ fibObjArr;

void Main() {
  @fibObjArr = array<FibObj@>(100000);
}


void RenderMenu() {
  if (UI::BeginMenu("Yield Testing")) {
    if (UI::MenuItem("Load Fib Objs")) {
      startnew(DoFibMethod);
    }
    UI::EndMenu();
  }
}

void Render() {
  lastFrameTime = Time::Now;
}


void YieldByTime() {
  uint64 curFrameTime = Time::get_Now() - lastFrameTime; 
  if (curFrameTime > MAX_FRAMETIME) {
    yield();
    num_yields += 1;
  }
}

void DoFibMethod() {
  array<int> results(20);
  int total = 0;
  for (int i = 0; i < 20; i++) {
    int c = _DoFibMethod();
    total += c;
    results.InsertLast(c);
  }
  print(total / 20);  
}


int _DoFibMethod() {
  uint64 totalTime = 0;
  startTime = Time::Now;
  num_yields = 0;
  fibObjArr.RemoveRange(0, fibObjArr.Length);
  fibObjArr.InsertLast(FibObj(0, 1));
  fibObjArr.InsertLast(FibObj(1, 2));
  uint64 start, end;
  
  for (int i = 2; i < MAX_FIB; i++) {
    start = Time::Now;
    fibObjArr.InsertLast(FibObj(fibObjArr[i - 2], fibObjArr[i - 1]));
    end = Time::Now;
    totalTime += end - start;
    YieldByTime();
  }
  print("Final fib number: " + tostring(fibObjArr[fibObjArr.Length - 1].val));
  print("Final fib time: " + tostring(fibObjArr[fibObjArr.Length - 1].time));
  print("Total execution time: " + tostring(totalTime));
  print("Total runtime: " + tostring(Time::Now - startTime));
  print("Number of yields: " + tostring(num_yields));

  return totalTime;
}