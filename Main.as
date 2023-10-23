void Main() {
}

ManyRunnables rootRunnable();

class FibObj {
}

class ManyRunnables {
    array<SmallestRunnable@> innerRunnableArray(100000000);
    ManyRunnables() {}
}

class SmallestRunnable {
    FibObj @fibOjbRunnable; 
    int p1, p2;
    SmallestRunnable() {} 
}