Class {
	#name : #PrfMethodProfilerDelayedRunner,
	#superclass : #Object,
	#instVars : [
		'intercepters',
		'profilingNow',
		'callStack',
		'result',
		'next',
		'array',
		'arrays',
		'limit'
	],
	#category : #MethodProfiler
}

{ #category : #'instance creation' }
PrfMethodProfilerDelayedRunner class >> newForMethods: aSetOfMethods [

	^ self new
		  methods: aSetOfMethods;
		  yourself
]

{ #category : #initialization }
PrfMethodProfilerDelayedRunner >> destroy [

	intercepters do: [ :intercepter | intercepter uninstall ].
	intercepters removeAll.
	result := nil.
]

{ #category : #'method flow' }
PrfMethodProfilerDelayedRunner >> enterMethod: aMethod [

	"Reserve the method, status and timestamp slots"
	| current |
	current := next.
	next := next + 3.
	
	next < array size ifTrue: [
		array at: current put: true.
		array at: current + 1 put: aMethod.
		array at: current + 2 put: Time primUTCMicrosecondsClock.
		^ self ].
	
	"Should grow! Allocate a new array and retry"
	self grow.
	^ self enterMethod: aMethod.
]

{ #category : #'method flow' }
PrfMethodProfilerDelayedRunner >> exitMethod: aMethod [

	"Reserve the method, status and timestamp slots"
	| current |
	current := next.
	next := next + 3.
	
	next < limit ifTrue: [
		array at: current put: false.
		array at: current + 1 put: aMethod.
		array at: current + 2 put: Time primUTCMicrosecondsClock.
		^ self ].
	
	"Should grow! Allocate a new array and retry"
	self grow.
	^ self exitMethod: aMethod.
]

{ #category : #'method flow' }
PrfMethodProfilerDelayedRunner >> grow [
	
	"Should grow! Allocate a new array and retry"
	array := Array new: array size * 2.
	limit := array size.
	next := 1.
	arrays add: array
]

{ #category : #initialization }
PrfMethodProfilerDelayedRunner >> initialize [
	result := PrfMethodProfilerResult new.
	callStack := PrfProcessCallStack newWithRunner: self.
	intercepters := Dictionary new.
	profilingNow := false.
	

	arrays := OrderedCollection new.
	array := Array new: 10000 * 3.
	limit := array size.
	next := 1.
	arrays add: array.
]

{ #category : #accessing }
PrfMethodProfilerDelayedRunner >> isProfilingNow [

	^ profilingNow
]

{ #category : #adding }
PrfMethodProfilerDelayedRunner >> methods: aSetOfMethods [
	(aSetOfMethods collect: [ :method | method unproxifiedMethod ]) do: [
		:method | intercepters at: method put: (PrfSpecializedMethodIntercepter newForMethod: method withRunner: self)].
	result methods: aSetOfMethods 
]

{ #category : #lifecycle }
PrfMethodProfilerDelayedRunner >> profile: aBlock [

	self start.
	aBlock ensure: [ self stop ].
	"result buildCallGraph."
	^ result
]

{ #category : #initialization }
PrfMethodProfilerDelayedRunner >> reset [ 
	result := PrfMethodProfilerResult new.
]

{ #category : #accessing }
PrfMethodProfilerDelayedRunner >> result [

	^ result
]

{ #category : #lifecycle }
PrfMethodProfilerDelayedRunner >> start [
	
	result mainProcess: thisProcess.
	intercepters do: [ :intercepter | intercepter install ].
	result rootNode enteringNode.
	profilingNow := true
]

{ #category : #lifecycle }
PrfMethodProfilerDelayedRunner >> stop [

	result rootNode exitingNode.
	intercepters do: [ :intercepter | intercepter uninstall ].
	profilingNow := false
]
