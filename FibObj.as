class FibObj {
    uint64 p1, p2, val, time;
    string str; 

    FibObj(int p1, int p2) {
        this.p1 = p1;
        this.p2 = p2;
        this.init();
    }

    FibObj(FibObj@ f1, FibObj@ f2) {
        this.p1 = f1.val;
        this.p2 = f2.val;
        this.time = Time::Now;
        this.init();
    }

    void init() {
        this.val = this.p1 + this.p2;
        this.str = tostring(this.val) + "\t" + tostring(this.p1) + "\t" + tostring(this.p2);
    }
}