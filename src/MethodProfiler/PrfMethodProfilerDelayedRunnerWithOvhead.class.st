Class {
	#name : #PrfMethodProfilerDelayedRunnerWithOvhead,
	#superclass : #Object,
	#instVars : [
		'intercepters',
		'profilingNow',
		'callStack',
		'result',
		'next',
		'array',
		'arrays'
	],
	#category : #MethodProfiler
}

{ #category : #'instance creation' }
PrfMethodProfilerDelayedRunnerWithOvhead class >> newForMethods: aSetOfMethods [

	^ self new
		  methods: aSetOfMethods;
		  yourself
]

{ #category : #initialization }
PrfMethodProfilerDelayedRunnerWithOvhead >> destroy [

	intercepters do: [ :intercepter | intercepter uninstall ].
	intercepters removeAll.
	result := nil.
]

{ #category : #'method flow' }
PrfMethodProfilerDelayedRunnerWithOvhead >> enterMethod: aMethod [

	"Reserve the method, status and timestamp slots"
	| current |
	current := next.
	next := next + 3.
	
	current + 2 < array size ifTrue: [
		array at: current put: true.
		array at: current + 1 put: aMethod.
		array at: current + 2 put: Time primUTCMicrosecondsClock.
		^ self ].
	
	"Should grow! Allocate a new array and retry"
	self grow.
	^ self enterMethod: aMethod.
]

{ #category : #'method flow' }
PrfMethodProfilerDelayedRunnerWithOvhead >> exitMethod: aMethod [

	"Reserve the method, status and timestamp slots"
	| current |
	current := next.
	next := next + 3.
	
	current + 2 < array size ifTrue: [
		array at: current put: false.
		array at: current + 1 put: aMethod.
		array at: current + 2 put: Time primUTCMicrosecondsClock.
		^ self ].
	
	"Should grow! Allocate a new array and retry"
	self grow.
	^ self exitMethod: aMethod.
]

{ #category : #'method flow' }
PrfMethodProfilerDelayedRunnerWithOvhead >> grow [
	
	"Should grow! Allocate a new array and retry"
	array := Array new: array size * 2.
	next := 1.
	arrays add: array
]

{ #category : #initialization }
PrfMethodProfilerDelayedRunnerWithOvhead >> initialize [
	result := PrfMethodProfilerResult new.
	callStack := PrfProcessCallStack newWithRunner: self.
	intercepters := Dictionary new.
	profilingNow := false.
	

	arrays := OrderedCollection new.
	array := Array new: 10000 * 3.
	next := 1.
	arrays add: array.
]

{ #category : #accessing }
PrfMethodProfilerDelayedRunnerWithOvhead >> isProfilingNow [

	^ profilingNow
]

{ #category : #adding }
PrfMethodProfilerDelayedRunnerWithOvhead >> methods: aSetOfMethods [
	(aSetOfMethods collect: [ :method | method unproxifiedMethod ]) do: [
		:method | intercepters at: method put: (PrfMethodIntercepter newForMethod: method withRunner: self)].
	result methods: aSetOfMethods 
]

{ #category : #lifecycle }
PrfMethodProfilerDelayedRunnerWithOvhead >> profile: aBlock [

	self start.
	aBlock ensure: [ self stop ].
	"result buildCallGraph."
	^ result
]

{ #category : #initialization }
PrfMethodProfilerDelayedRunnerWithOvhead >> reset [ 
	result := PrfMethodProfilerResult new.
]

{ #category : #accessing }
PrfMethodProfilerDelayedRunnerWithOvhead >> result [

	^ result
]

{ #category : #lifecycle }
PrfMethodProfilerDelayedRunnerWithOvhead >> start [
	
	result mainProcess: thisProcess.
	intercepters do: [ :intercepter | intercepter install ].
	result rootNode enteringNode.
	profilingNow := true
]

{ #category : #lifecycle }
PrfMethodProfilerDelayedRunnerWithOvhead >> stop [

	result rootNode exitingNode.
	intercepters do: [ :intercepter | intercepter uninstall ].
	profilingNow := false
]
