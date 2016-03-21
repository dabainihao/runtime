# runtime
<p> 0. runtime 简称运行时,就是程序在运行时的一些机制,其中最主要的是消息机制,对于c语言,函数在编译的过程就确定调用那个函数,编译完成之后顺序执行,无二义性.oc的函数调用称之为消息发送,属于动态调用过程,在编译的过程中不能决定调用哪个函数(事实证明，在编 译阶段，OC可以调用任何函数，即使这个函数并未实现，只要申明过就不会报错。而C语言在编译阶段就会报错),只有在真正运行的时候才会根据函数的名称找 到对应的函数来调用 </p>
<p>1. obj-c是一门面向对象的编程语言,每个对象都是一类类的实例,在obj-c语言的内部,每个对象都有一个名为isa的指针,指向该对象的类,每个类描述了一系列他的实例的特点,包括成员变量,成员函数的列表等,每个对象可以介绍消息,而对象可以介绍的消息列表保存在他对应的类中</p>

<p >2. 在oc中类方法的解释: 在oc中类也是对象,是另外一个类的实例,这个类是元类(metaclass),元类保存了类方法的实现列表,当一个类方法被调用的时候,元类会首先查找这个方法本身是否有改方法的实现,如果没有元类会向它的父类查找该方法,这样一直找到他继承链的头; 元类也是对象,元类的isa指针指向根元类(root metaclass),根元类的isa指针指向自己,这样子就形成一个闭环</p>

<p> <img src = "http://cn.cocos2d-x.org/uploads/20141018/1413628797629491.png" width = 300px height = 300px> isa和继承的关系</p>

<p> 3. 类的实例可以看成c语言的结构体, isa指针是这个结构的第一个元素,其他成员变量一次排列在结构体中,这个结构体的大小是无法动态的修改的,所以无法在运行时动态的给对象添加成员变量 </p>

<p> 4. 对象的方法定义在类的可变区域内,方法定义的列表是一个指向methodLists的指针的指针,修改这个指针指向的值, 我们就可以动态的为一个类添加成员方法,这就是category的实现原理,这也是为什么category指针添加成员方法不能添加对象,通过objc_setAssociatedObject和objc_getAssociatedObject可以变相的为对象添加成员变量,但实现机制不一样,没有办法真正改变对象的内存结构 </p>
<p >5. isa本身也是一个指针, 我们除了对象的方法可以动态的修改外,我们也可以在运行时动态的修改isa指针的值,达到替换整个对象行为的目的 </p>
<p >6. 动态创建对象: <pre> // 创建一个类CustomView是UIView的子类,为这个类分配空间
    Class newClass = objc_allocateClassPair([UIView class], "CustomView", 0);
    //  为这个类添加一个方法
    class_addMethod(newClass, @selector(report), (IMP)reportFunction, "V@:");
    // 注册这个类 , 让这个类可以使用
    objc_registerClassPair(newClass);
    // 创建一个CustomView实例
    id custom = [[newClass alloc] init];
    // 调用一个方法
    [custom performSelector:@selector(report) withObject:nil]; </pre></p>
<div >7. swizzling的应用 :
    <p style="text-indent:2em">1. class_replaceMethod 替换类方法的定义(被替换的方法可能不存在) <br> <p style="text-indent:2em"> 2.method_exchangImplementations 交换两个方法的实现(需要交换两个方法的实现)</p> <p style="text-indent:2em">3.method_setImplementation设置一个方法的实现(为一个方法设置实现的时候) </p></p>
</div>

