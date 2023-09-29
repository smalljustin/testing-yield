[Setting drag min=5 max=50]
uint64 MAX_FRAMETIME = 1;

[Setting drag min=1000 max=100000]
int MAX_FIB = 10000;

[Setting drag min=1 max=30000]
int NUM_ARR_COPY = 5;

[Setting name="Dummy bool"]
bool DUMMY = false;

[Setting name="Initialize on startup"]
bool INIT_ON_STARTUP = false;

[Setting name="Number of runnables to spawn" drag min=1000 max=1000000]
int NUM_RUNNABLES = 1000;

[Setting name="Do work in coroutine?"]
bool DO_COROUTINE = false;

[Setting name="Use multiple ManyRunnables objects - this will crash the game"]
bool USE_MANY_MANYRUNNABLES = false;

[Setting name="Do yielding inside working loops"]
bool YIELD = false;

uint64 lastFrameTime = Time::Now;
uint64 startTime = Time::Now;
int num_yields = 0;
bool copyLock;

array<FibObj@>@ fibObjArr;
array<array<FibObj@>@>@ subArr;
array<uint64>@ p1Arr, p2Arr, valArr, timeArr;
array<string>@ strArr;

void Main() {
  @fibObjArr = array<FibObj@>(100000);
  @subArr = array<array<FibObj@>@>();

  @p1Arr = array<uint64>();
  @p2Arr = array<uint64>();
  @valArr = array<uint64>();
  @timeArr = array<uint64>();
  @strArr = array<string>();
  if (INIT_ON_STARTUP) {
    startnew(DoFibMethod);
  }
}

void RenderMenu() {
  if (UI::BeginMenu("Yield Testing")) {
    if (UI::MenuItem("Init Fib Objs")) {
      startnew(DoFibMethod);
    }
    if (UI::MenuItem("Re copy object refs")) {
      startnew(ReCopyObjRefs);
    }
    if (UI::MenuItem("Do coroutine count testing")) {
      startnew(DoCoroutineCountTest);
    }
    UI::EndMenu();
  }
}

ManyRunnables rootRunnable();

void Render() {
  lastFrameTime = Time::Now;
}

int total_coroutines = 0;
int total_yields = 0;
void DoCoroutineCountTest() {
  ManyRunnables@ runnable;
  if (USE_MANY_MANYRUNNABLES) {
    @runnable = @ManyRunnables();
  } else {
    @runnable = @rootRunnable;
  }

  print("Test beginning! Count: " + tostring(NUM_RUNNABLES) + ", coroutines: " + tostring(DO_COROUTINE));
  total_coroutines = 0;
  total_yields = 0;
  uint64 diff;
  uint64 begin = Time::Now;
  print("Starting runnable!");
  runnable.Init();
  uint64 init = Time::Now;
  
  diff = init - begin;
  print("At init: time " + tostring(diff));
  runnable.Start();
  uint64 start = Time::Now;
  diff = start - init;
  print("At start: time " + tostring(diff));
  int result = runnable.getResult();
  uint64 end = Time::Now;
  diff = end - start;
  print("At end: time " + tostring(diff));
  print("Resulting time: " + tostring(end - begin));
  print("Calculated result: " + tostring(result));
  print("Total coroutines: " + tostring(total_coroutines));
  print("Total yields: " + tostring(total_yields));

  print("Ending coroutine test.");
}

void YieldByTime() {
  uint64 curFrameTime = Time::get_Now() - lastFrameTime; 
  if (curFrameTime > MAX_FRAMETIME) {
    yield();
    total_yields += 1;
  }
}


void DoFibMethod() {
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
}

void ReCopyObjRefs() {
  if (copyLock) {
    print("Locked! Bouncing...");
    return;
  }
  copyLock = true;
  p1Arr.RemoveRange(0, p1Arr.Length);
  p2Arr.RemoveRange(0, p2Arr.Length);
  valArr.RemoveRange(0, valArr.Length);
  timeArr.RemoveRange(0, timeArr.Length);
  strArr.RemoveRange(0, strArr.Length);

  print("Reserve size: " + tostring(NUM_ARR_COPY * MAX_FIB));
  p1Arr.Reserve(NUM_ARR_COPY * MAX_FIB);
  p2Arr.Reserve(NUM_ARR_COPY * MAX_FIB);
  valArr.Reserve(NUM_ARR_COPY * MAX_FIB);
  timeArr.Reserve(NUM_ARR_COPY * MAX_FIB);
  strArr.Reserve(NUM_ARR_COPY * MAX_FIB);

  for (int i = 0; i < NUM_ARR_COPY; i++) {
    print(i);
    if (subArr.Length < i + 1) {
      subArr.InsertLast(array<FibObj@>());
      YieldByTime();
    }
    array<FibObj@>@ curArr = subArr[i];
    curArr.RemoveRange(0, curArr.Length);
    for (int j = 0; j < fibObjArr.Length; j++) {
      YieldByTime();
      curArr.InsertLast(fibObjArr[j]);
      p1Arr.InsertLast(fibObjArr[j].p1);
      p2Arr.InsertLast(fibObjArr[j].p2);
      valArr.InsertLast(fibObjArr[j].val);
      timeArr.InsertLast(fibObjArr[j].time);
      strArr.InsertLast(fibObjArr[j].str);
    }
  }
  print("Copy completed!");
  copyLock = false;
}

// void OnSettingsChanged() {
//   print("Re-copying object refs");
//   startnew(ReCopyObjRefs);
// }