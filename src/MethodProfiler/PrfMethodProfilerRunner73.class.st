Class {
	#name : #PrfMethodProfilerRunner73,
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
PrfMethodProfilerRunner73 class >> newForMethods: aSetOfMethods [

	^ self new
		  methods: aSetOfMethods;
		  yourself
]

{ #category : #initialization }
PrfMethodProfilerRunner73 >> destroy [

	intercepters do: [ :intercepter | intercepter uninstall ].
	intercepters removeAll.
	result := nil.
]

{ #category : #'method flow' }
PrfMethodProfilerRunner73 >> enterMethod: aMethod [

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
PrfMethodProfilerRunner73 >> exitMethod: aMethod [

	callStack pop exitingNode
]

{ #category : #initialization }
PrfMethodProfilerRunner73 >> initialize [
	result := PrfMethodProfilerResult new.
	callStack := PrfProcessCallStack newWithRunner: self.
	intercepters := Dictionary new.
	profilingNow := false
]

{ #category : #accessing }
PrfMethodProfilerRunner73 >> isProfilingNow [

	^ profilingNow
]

{ #category : #adding }
PrfMethodProfilerRunner73 >> methods: aSetOfMethods [
	(aSetOfMethods collect: [ :method | method unproxifiedMethod ]) do: [
		:method | intercepters at: method put: (PrfMethodIntercepter73 newForMethod: method withRunner: self)].
	result methods: aSetOfMethods 
]

{ #category : #lifecycle }
PrfMethodProfilerRunner73 >> profile: aBlock [

	self start.
	aBlock ensure: [ self stop ].
	"result buildCallGraph."
	^ result
]

{ #category : #initialization }
PrfMethodProfilerRunner73 >> reset [ 
	result := PrfMethodProfilerResult new.
]

{ #category : #accessing }
PrfMethodProfilerRunner73 >> result [

	^ result
]

{ #category : #lifecycle }
PrfMethodProfilerRunner73 >> start [
	
	result mainProcess: thisProcess.
	intercepters do: [ :intercepter | intercepter install ].
	result rootNode enteringNode.
	profilingNow := true
]

{ #category : #lifecycle }
PrfMethodProfilerRunner73 >> stop [

	result rootNode exitingNode.
	intercepters do: [ :intercepter | intercepter uninstall ].
	profilingNow := false
]