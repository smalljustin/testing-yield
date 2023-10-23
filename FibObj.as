class FibObj {
    uint64 p1, p2, val, time;
    string str; 

    FibObj(int p1, int p2) {
    }

    FibObj(FibObj@ f1, FibObj@ f2) {
    }

    void init() {
    }
}

class ManyRunnables {
    array<SmallestRunnable@> innerRunnableArray(100000000);

    void Init() {
        for (int i = 0; i < NUM_RUNNABLES; i++) {
            @innerRunnableArray[i] = @SmallestRunnable(i, i + 1);
            if (YIELD) YieldByTime();

        }
    }

    void Start() {
        for (int i = 0; i < NUM_RUNNABLES; i++) {
            innerRunnableArray[i].Start();
            if (YIELD) YieldByTime();
        }
    }

    int getResult() {
        int resultSum = 0;
        for (int i = 0; i < NUM_RUNNABLES; i++) {
            resultSum += innerRunnableArray[i].getResult();
            if (YIELD) YieldByTime();
        }
        return resultSum;
    }
}

class SmallestRunnable {
    FibObj @fibOjbRunnable; 
    int p1, p2;
    
    SmallestRunnable() {} 
    SmallestRunnable(int p1, int p2) {
        this.p1 = p1;
        this.p2 = p2;
    }

    void Start() {
        if (DO_COROUTINE) {
            startnew(CoroutineFunc(this._Start));
            total_coroutines += 1;
        }
        else
            this._Start();
    }

    void _Start() {
        @fibOjbRunnable = @FibObj(p1, p2);
    }

    int getResult() {
        while (fibOjbRunnable is null) {
            YieldByTime();
        }
        return fibOjbRunnable.val;
    }
}