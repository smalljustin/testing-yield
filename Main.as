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
}

ManyRunnables rootRunnable();

void Render() {
  lastFrameTime = Time::Now;
}

int total_coroutines = 0;
int total_yields = 0;

void YieldByTime() {
  uint64 curFrameTime = Time::get_Now() - lastFrameTime; 
  if (curFrameTime > MAX_FRAMETIME) {
    yield();
    total_yields += 1;
  }
}
