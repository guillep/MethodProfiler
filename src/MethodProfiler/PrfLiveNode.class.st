Class {
	#name : #PrfLiveNode,
	#superclass : #PrfNode,
	#instVars : [
		'nodeHash',
		'lastTimeEntered',
		'totalTime',
		'callTimes'
	],
	#category : #MethodProfiler
}

{ #category : #'method flow' }
PrfLiveNode >> enteringNode [
	lastTimeEntered := Time primUTCMicrosecondsClock
]

{ #category : #'method flow' }
PrfLiveNode >> exitingNode [
	"Manage the case of the root unknown node"
	| timeOfCall |
	lastTimeEntered ifNil: [ ^ self ].

	timeOfCall := (Time primUTCMicrosecondsClock - lastTimeEntered) max: 1.
	"callTimes add: timeOfCall."
	totalTime := totalTime + timeOfCall.
	lastTimeEntered := nil 
]

{ #category : #initialization }
PrfLiveNode >> initialize [

	super initialize.
	totalTime := 0.
	callTimes := OrderedCollection new
]

{ #category : #accessing }
PrfLiveNode >> nodeHash [

	^ nodeHash
]

{ #category : #accessing }
PrfLiveNode >> nodeHash: anObject [

	nodeHash := anObject
]

{ #category : #accessing }
PrfLiveNode >> totalTime [

	^ totalTime
]
