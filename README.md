# ThreadOCDemo
demo中详细介绍了GCD队列与线程的关系，代码中有详细的注释

#GCG中的队列主要分两种：

  并发队列 (同步：当前线程，一个一个执行      异步：开很多线程，一起执行)
  
  串行队列（同步：当前线程，一个一个执行      异步：其他线程，一个一个执行）
  


  当我们创建了队列之后，我们需要把任务添加到队列中，并指定以同步还是异步的方式执行添加到队列中的任务。 

  同步，其会在当前线程立即执行添加的任务(无论是串行还是并行队列都如此)。 
  
  异步，其会新创建一个新的线程来执行任务。而异步对于串行和并行队列的又不一样的意义的。 
  
  对于异步执行的串行队列的话，新添加的多个任务会在新创建的线程中依次执行，即一个执行完在执行另一个任务，有点类似同步执行的样子（其区别可以看做是同步不会创建新的线程，而异步会创建新的线程，且只创建一个）
  

#主线程串行队列

#主线程并行队列

#全局线程串行队列

#全局线程并行队列

#serial线程串行队列

#serial线程并行队列
