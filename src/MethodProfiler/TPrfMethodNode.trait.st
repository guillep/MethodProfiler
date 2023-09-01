Trait {
	#name : #TPrfMethodNode,
	#instVars : [
		'method'
	],
	#category : #MethodProfiler
}

{ #category : #accessing }
TPrfMethodNode >> method: anObject [

	method := anObject
]

{ #category : #converting }
TPrfMethodNode >> printOn: aStream [

	super printOn: aStream.
	aStream
		nextPutAll: '(';
		nextPutAll: method name;
		nextPutAll: ')'
]

{ #category : #converting }
TPrfMethodNode >> printString [
	^method printString
]
