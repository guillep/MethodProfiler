Class {
	#name : #PrfInstrumentationUnwinder,
	#superclass : #InstrumentationEnsurer,
	#instVars : [
		'executed',
		'runner',
		'proxifiedMethod'
	],
	#category : #MethodProfiler
}

{ #category : #'instance creation' }
PrfInstrumentationUnwinder class >> newWithHandler: aHandler receiver: receiver arguments: arguments [

	^ self new
		  handler: aHandler;
		  receiver: receiver;
		  arguments: arguments;
		  yourself
]

{ #category : #accessing }
PrfInstrumentationUnwinder >> executed [

	^ executed
]

{ #category : #accessing }
PrfInstrumentationUnwinder >> executed: anObject [

	executed := anObject
]

{ #category : #accessing }
PrfInstrumentationUnwinder >> proxifiedMethod [

	^ proxifiedMethod
]

{ #category : #accessing }
PrfInstrumentationUnwinder >> proxifiedMethod: anObject [

	proxifiedMethod := anObject
]

{ #category : #accessing }
PrfInstrumentationUnwinder >> runner [

	^ runner
]

{ #category : #accessing }
PrfInstrumentationUnwinder >> runner: anObject [

	runner := anObject
]

{ #category : #evaluating }
PrfInstrumentationUnwinder >> value [

	<methodProxyCannotWrap>
	executed := true.
	thisProcess runInMetaLevel: [
		^ runner exitMethod: proxifiedMethod ]
]
