Class {
	#name : #PrfMethodProfilerRunner2,
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
PrfMethodProfilerRunner2 class >> newForMethods: aSetOfMethods [

	^ self new
		  methods: aSetOfMethods;
		  yourself
]

{ #category : #initialization }
PrfMethodProfilerRunner2 >> destroy [

	intercepters do: [ :intercepter | intercepter uninstall ].
	intercepters removeAll.
	result := nil.
]

{ #category : #'method flow' }
PrfMethodProfilerRunner2 >> enterMethod: aMethod [

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
PrfMethodProfilerRunner2 >> exitMethod: aMethod [

	callStack pop exitingNode
]

{ #category : #initialization }
PrfMethodProfilerRunner2 >> initialize [
	result := PrfMethodProfilerResult new.
	callStack := PrfProcessCallStack newWithRunner: self.
	intercepters := Dictionary new.
	profilingNow := false
]

{ #category : #accessing }
PrfMethodProfilerRunner2 >> isProfilingNow [

	^ profilingNow
]

{ #category : #adding }
PrfMethodProfilerRunner2 >> methods: aSetOfMethods [
	(aSetOfMethods collect: [ :method | method unproxifiedMethod ]) do: [
		:method | intercepters at: method put: (PrfMethodIntercepter2 newForMethod: method withRunner: self)].
	result methods: aSetOfMethods 
]

{ #category : #lifecycle }
PrfMethodProfilerRunner2 >> profile: aBlock [

	self start.
	aBlock ensure: [ self stop ].
	"result buildCallGraph."
	^ result
]

{ #category : #initialization }
PrfMethodProfilerRunner2 >> reset [ 
	result := PrfMethodProfilerResult new.
]

{ #category : #accessing }
PrfMethodProfilerRunner2 >> result [

	^ result
]

{ #category : #lifecycle }
PrfMethodProfilerRunner2 >> start [
	
	result mainProcess: thisProcess.
	intercepters do: [ :intercepter | intercepter install ].
	result rootNode enteringNode.
	profilingNow := true
]

{ #category : #lifecycle }
PrfMethodProfilerRunner2 >> stop [

	result rootNode exitingNode.
	intercepters do: [ :intercepter | intercepter uninstall ].
	profilingNow := false
]
