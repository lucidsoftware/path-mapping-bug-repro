This is a minimal repro case for a Bazel problem where a multiplex worker is not run when multiplex sandboxing and path mapping are enabled.

If multiplex workers are disabled, then the worker runs. The worker still fails as it doesn't do anything, but it actually runs.

The error seems to be that the executable is not available in the sandbox and thus the worker cannot be run. See the full error below for more information.

*Dependencies required*\
[bazelisk](https://github.com/bazelbuild/bazelisk)

*To reproduce the problem*\
Run `bazel build example`

*To mitigate the problem*\
uncomment the `noworker_multiplex` line in `.bazelrc`

*Error seen*

```
foo@foo:~/opensource/path-mapping-bug-repro$ bazel build example
Starting local Bazel server and connecting to it...
INFO: Invocation ID: 5ed74651-5cbb-40e8-ae72-00c8e8d5e72c
INFO: Analyzed target //example:example (97 packages loaded, 711 targets configured).
ERROR: /home/foo/opensource/path-mapping-bug-repro/example/BUILD.bazel:10:13: Running example worker on //example:example failed: IOException while preparing the execution environment of a worker:

---8<---8<--- Exception details ---8<---8<---
java.io.IOException: Cannot run program "/home/foo/.cache/bazel/_bazel_foo/4df6eac11fc9b83385e43e65aa0701cc/bazel-workers/ExampleRun-multiplex-worker-workdir/_main/bazel-out/cfg/bin/example/example_worker" (in directory "/home/foo/.cache/bazel/_bazel_foo/4df6eac11fc9b83385e43e65aa0701cc/bazel-workers/ExampleRun-multiplex-worker-workdir/_main"): error=2, No such file or directory
	at java.base/java.lang.ProcessBuilder.start(Unknown Source)
	at java.base/java.lang.ProcessBuilder.start(Unknown Source)
	at com.google.devtools.build.lib.shell.JavaSubprocessFactory.start(JavaSubprocessFactory.java:152)
	at com.google.devtools.build.lib.shell.JavaSubprocessFactory.create(JavaSubprocessFactory.java:182)
	at com.google.devtools.build.lib.shell.SubprocessBuilder.start(SubprocessBuilder.java:251)
	at com.google.devtools.build.lib.worker.WorkerMultiplexer.createProcess(WorkerMultiplexer.java:197)
	at com.google.devtools.build.lib.worker.WorkerMultiplexer.createSandboxedProcess(WorkerMultiplexer.java:162)
	at com.google.devtools.build.lib.worker.SandboxedWorkerProxy.prepareExecution(SandboxedWorkerProxy.java:71)
	at com.google.devtools.build.lib.worker.WorkerSpawnRunner.executeRequest(WorkerSpawnRunner.java:521)
	at com.google.devtools.build.lib.worker.WorkerSpawnRunner.execInWorker(WorkerSpawnRunner.java:414)
	at com.google.devtools.build.lib.worker.WorkerSpawnRunner.exec(WorkerSpawnRunner.java:199)
	at com.google.devtools.build.lib.exec.AbstractSpawnStrategy.exec(AbstractSpawnStrategy.java:158)
	at com.google.devtools.build.lib.exec.AbstractSpawnStrategy.exec(AbstractSpawnStrategy.java:118)
	at com.google.devtools.build.lib.exec.SpawnStrategyResolver.exec(SpawnStrategyResolver.java:45)
	at com.google.devtools.build.lib.analysis.actions.SpawnAction.execute(SpawnAction.java:263)
	at com.google.devtools.build.lib.skyframe.SkyframeActionExecutor$ActionRunner.executeAction(SkyframeActionExecutor.java:1159)
	at com.google.devtools.build.lib.skyframe.SkyframeActionExecutor$ActionRunner.run(SkyframeActionExecutor.java:1076)
	at com.google.devtools.build.lib.skyframe.ActionExecutionState.runStateMachine(ActionExecutionState.java:165)
	at com.google.devtools.build.lib.skyframe.ActionExecutionState.getResultOrDependOnFuture(ActionExecutionState.java:94)
	at com.google.devtools.build.lib.skyframe.SkyframeActionExecutor.executeAction(SkyframeActionExecutor.java:573)
	at com.google.devtools.build.lib.skyframe.ActionExecutionFunction.checkCacheAndExecuteIfNeeded(ActionExecutionFunction.java:862)
	at com.google.devtools.build.lib.skyframe.ActionExecutionFunction.computeInternal(ActionExecutionFunction.java:334)
	at com.google.devtools.build.lib.skyframe.ActionExecutionFunction.compute(ActionExecutionFunction.java:172)
	at com.google.devtools.build.skyframe.AbstractParallelEvaluator$Evaluate.run(AbstractParallelEvaluator.java:461)
	at com.google.devtools.build.lib.concurrent.AbstractQueueVisitor$WrappedRunnable.run(AbstractQueueVisitor.java:414)
	at java.base/java.util.concurrent.ForkJoinTask$RunnableExecuteAction.exec(Unknown Source)
	at java.base/java.util.concurrent.ForkJoinTask.doExec(Unknown Source)
	at java.base/java.util.concurrent.ForkJoinPool$WorkQueue.topLevelExec(Unknown Source)
	at java.base/java.util.concurrent.ForkJoinPool.scan(Unknown Source)
	at java.base/java.util.concurrent.ForkJoinPool.runWorker(Unknown Source)
	at java.base/java.util.concurrent.ForkJoinWorkerThread.run(Unknown Source)
Caused by: java.io.IOException: error=2, No such file or directory
	at java.base/java.lang.ProcessImpl.forkAndExec(Native Method)
	at java.base/java.lang.ProcessImpl.<init>(Unknown Source)
	at java.base/java.lang.ProcessImpl.start(Unknown Source)
	... 31 more
---8<---8<--- End of exception details ---8<---8<---

---8<---8<--- Start of log, file at /home/foo/.cache/bazel/_bazel_foo/4df6eac11fc9b83385e43e65aa0701cc/bazel-workers/multiplex-worker-2-ExampleRun.log ---8<---8<---
(empty)

```