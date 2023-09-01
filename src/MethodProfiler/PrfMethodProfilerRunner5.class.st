Class {
	#name : #PrfMethodProfilerRunner5,
	#superclass : #Object,
	#instVars : [
		'intercepters',
		'profilingNow',
		'callStack',
		'result'
	],
	#category : #MethodProfiler
}

{ #category : #'instance creation' }
PrfMethodProfilerRunner5 class >> newForMethods: aSetOfMethods [

	^ self new
		  methods: aSetOfMethods;
		  yourself
]

{ #category : #initialization }
PrfMethodProfilerRunner5 >> destroy [

	intercepters do: [ :intercepter | intercepter uninstall ].
	intercepters removeAll.
	result := nil.
]

{ #category : #'method flow' }
PrfMethodProfilerRunner5 >> enterMethod: aMethod [

	| node precedingNode |
	callStack ensureStackIsInitialized.
	precedingNode := callStack top.
	node := result
		        nodeForMethod: aMethod
		        withPrecedingNode: precedingNode.
	precedingNode addCallTo: node.
	node addCall.
	callStack push: node.
	node enteringNode
]

{ #category : #'method flow' }
PrfMethodProfilerRunner5 >> exitMethod: aMethod [

	callStack pop exitingNode
]

{ #category : #initialization }
PrfMethodProfilerRunner5 >> initialize [
	result := PrfMethodProfilerResult new.
	callStack := PrfProcessCallStack newWithRunner: self.
	intercepters := Dictionary new.
	profilingNow := false
]

{ #category : #accessing }
PrfMethodProfilerRunner5 >> isProfilingNow [

	^ profilingNow
]

{ #category : #adding }
PrfMethodProfilerRunner5 >> methods: aSetOfMethods [
	(aSetOfMethods collect: [ :method | method unproxifiedMethod ]) do: [
		:method | intercepters at: method put: (PrfMethodIntercepter5 newForMethod: method withRunner: self)].
	result methods: aSetOfMethods 
]

{ #category : #lifecycle }
PrfMethodProfilerRunner5 >> profile: aBlock [

	self start.
	aBlock ensure: [ self stop ].
	"result buildCallGraph."
	^ result
]

{ #category : #initialization }
PrfMethodProfilerRunner5 >> reset [ 
	result := PrfMethodProfilerResult new.
]

{ #category : #accessing }
PrfMethodProfilerRunner5 >> result [

	^ result
]

{ #category : #lifecycle }
PrfMethodProfilerRunner5 >> start [
	
	result mainProcess: thisProcess.
	intercepters do: [ :intercepter | intercepter install ].
	result rootNode enteringNode.
	profilingNow := true
]

{ #category : #lifecycle }
PrfMethodProfilerRunner5 >> stop [

	result rootNode exitingNode.
	intercepters do: [ :intercepter | intercepter uninstall ].
	profilingNow := false
]
