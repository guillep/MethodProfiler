Class {
	#name : #PrfMethodProxy,
	#superclass : #Object,
	#instVars : [
		'selector',
		'methodClass',
		'isDisabled',
		'handler',
		'proxifiedMethod',
		'deactivator',
		'ownerProcess',
		'runner'
	],
	#category : #MethodProfiler
}

{ #category : #'reflective operations' }
PrfMethodProxy class >> doesNotUnderstand: aMessage [

	^ CompiledMethod 
		  perform: aMessage selector
		  withArguments: aMessage arguments
]

{ #category : #'instance creation' }
PrfMethodProxy class >> on: selector inClass: aClass handler: aHandler [

	| proxy |
	proxy := self new.
	proxy class: aClass selector: selector.
	proxy handler: aHandler.
	^ proxy
]

{ #category : #'instance creation' }
PrfMethodProxy class >> onMethod: aMethod handler: aHandler [

	^ self on: aMethod selector inClass: aMethod methodClass handler: aHandler
]

{ #category : #private }
PrfMethodProxy class >> uninstallAllWrappers [
	"self uninstallAllWrappers"

	self allSubInstancesDo: [ :inst | inst uninstall ]
]

{ #category : #comparing }
PrfMethodProxy >> = anObject [
	"Answer whether the receiver and the argument represent the same
	object. If = is redefined in any subclass, consider also redefining the
	message hash."

	^ self == anObject
]

{ #category : #evaluating }
PrfMethodProxy >> activeProcess [
	
	^ thisProcess
]

{ #category : #accessing }
PrfMethodProxy >> calypsoEnvironmentType [
	^ proxifiedMethod 
			ifNotNil: [ proxifiedMethod calypsoEnvironmentType ]
			ifNil: [ super calypsoEnvironmentType ]
			
]

{ #category : #initialization }
PrfMethodProxy >> class: aClass selector: aSymbol [

	self
		methodClass: aClass;
		selector: aSymbol
]

{ #category : #accessing }
PrfMethodProxy >> disable [

	isDisabled := true
]

{ #category : #accessing }
PrfMethodProxy >> doesNotUnderstand: aMessage [
	^ proxifiedMethod 
			ifNotNil: [ proxifiedMethod 
								perform: aMessage selector 
								withArguments: aMessage arguments ]
			ifNil: [ super doesNotUnderstand: aMessage ]
			
]

{ #category : #accessing }
PrfMethodProxy >> fetchMethod [
	
	"Fetches the method to be instrumented"
	^ methodClass >> selector
]

{ #category : #installation }
PrfMethodProxy >> handler [

	^ handler
]

{ #category : #accessing }
PrfMethodProxy >> handler: aHandler [

	handler := aHandler
]

{ #category : #initialization }
PrfMethodProxy >> initialize [

	super initialize.
	isDisabled := true.
	deactivator := InstrumentationDeactivator new
]

{ #category : #evaluating }
PrfMethodProxy >> insEnsureAfter: aBlock withReceiver: aReceiver arguments: anArrayOfObjects result: aResult [
	"I am a re-implementation of the method BlockClosure>>#ensure: and I have the same code
	except for the <noInstrumentation> pragma. I re-implement this method because when
	instrumenting I need to use the BlockClosure>>#ensure: method but if one instruments the
	method BlockClosure>>#ensure: I will enter to an endless loop."

	<noInstrumentation>
	<primitive: 198>
	| complete returnValue |
	returnValue := handler
		  afterExecutionWithReceiver: aReceiver
		  arguments: anArrayOfObjects
		  returnValue: aResult.
	complete ifNil: [
		complete := true.
		aBlock value ].
	^ returnValue
]

{ #category : #evaluating }
PrfMethodProxy >> insEnsureBefore: aBlock withReceiver: aReceiver arguments: anArrayOfObjects [
	"I am a re-implementation of the method BlockClosure>>#ensure: and I have the same code
	except for the <noInstrumentation> pragma. I re-implement this method because when
	instrumenting I need to use the BlockClosure>>#ensure: method but if one instruments the
	method BlockClosure>>#ensure: I will enter to an endless loop."

	<noInstrumentation>
	<primitive: 198>
	| complete returnValue |
	returnValue := handler
		beforeExecutionWithReceiver: aReceiver
		arguments: anArrayOfObjects.
	complete ifNil: [
		complete := true.
		aBlock value ].
	^ returnValue
]

{ #category : #evaluating }
PrfMethodProxy >> insExecuteMethodEnsuring: aBlock receiver: aReceiver withArgs: anArrayOfObjects [
	"I am a re-implementation of the method BlockClosure>>#ensure: and I have the same code
	except for the <noInstrumentation> pragma. I re-implement this method because when
	instrumenting I need to use the BlockClosure>>#ensure: method but if one instruments the
	method BlockClosure>>#ensure: I will enter to an endless loop."

	<noInstrumentation>
	<primitive: 198>
	| complete returnValue |
	returnValue := self
		               receiver: aReceiver
		               withArgs: anArrayOfObjects
		               executeMethod: proxifiedMethod.
	complete ifNil: [
		complete := true.
		aBlock value ].
	^ returnValue
]

{ #category : #installation }
PrfMethodProxy >> install [
	"We have a method proxy with a method = class * selector of the method it will proxy."
	
	|  method |
	method := methodClass compiledMethodAt: selector ifAbsent: [ 
		MpCannotInstall signalWith: self ].
	
	(self shouldWrap: method) ifFalse: [ 
		MpCannotInstall signalWith: self ].
	
	self unproxifiedMethod: method.
	methodClass methodDict at: selector put: self.
	
	"Activate it now"
	isDisabled := false.
	^ self
]

{ #category : #accessing }
PrfMethodProxy >> isEnabled [

	^ isDisabled not
]

{ #category : #accessing }
PrfMethodProxy >> isEnabled: anObject [

	isDisabled := anObject not
]

{ #category : #testing }
PrfMethodProxy >> isInstalled [
	"Return whether the receiver is effectively installed in a method dictionary.
	Note that in the case of nesting of method proxies the inner ones are not considered as installed."
	
	methodClass ifNotNil: [
		selector ifNotNil: [ 
			^ self == (methodClass methodDict at: selector ifAbsent: [])]].
	^ false
]

{ #category : #testing }
PrfMethodProxy >> isMethodProxy [

	^ true
]

{ #category : #accessing }
PrfMethodProxy >> methodClass [
	^ methodClass
]

{ #category : #accessing }
PrfMethodProxy >> methodClass: aClass [

	methodClass := aClass
]

{ #category : #evaluating }
PrfMethodProxy >> name [

	^ self printString
]

{ #category : #printing }
PrfMethodProxy >> printOn: aStream [

	aStream
		nextPutAll: self class name;
		nextPutAll: '[';
		nextPutAll: methodClass name;
		nextPutAll: '>>#';
		nextPutAll: selector;
		nextPutAll: ']'
]

{ #category : #evaluating }
PrfMethodProxy >> receiver: aReceiver withArgs: argArray executeMethod: compiledMethod [
	"Execute compiledMethod against the receiver and args in argArray"

	<primitive: 188>
	<methodProxyCannotWrap>
	self primitiveFailed
]

{ #category : #evaluating }
PrfMethodProxy >> run: aSelector with: anArrayOfObjects in: aReceiver [
	"Do not intercept"

	<methodProxyCannotWrap>
	| result process unwinder |
	process := self activeProcess.

	"Fast path: I'm in a single threaded no conflict case"
	ownerProcess ifNil: [
		ownerProcess := process.
		runner enterMethod: proxifiedMethod.
		[
		ownerProcess := nil.
		result := self
			          receiver: aReceiver
			          withArgs: anArrayOfObjects
			          executeMethod: proxifiedMethod.
		ownerProcess := process. ] ensure: [
			ownerProcess := process.
			"handler afterMethod."
			runner exitMethod: proxifiedMethod. ].
		ownerProcess := nil.
		^ result ].

	"Slow case: I'm being called recursively!
	Trhee cases: 
	 - the recursive call is in the same thread, do no instrumentation.
	 - the recursive call is in another thread, do no instrumentation.
	 - the first call in another thread, use the expensive instrumentation."
	ownerProcess == process ifTrue: [
		^ self
			  receiver: aReceiver
			  withArgs: anArrayOfObjects
			  executeMethod: proxifiedMethod ].

	process isMeta ifTrue: [
		^ self
			  receiver: aReceiver
			  withArgs: anArrayOfObjects
			  executeMethod: proxifiedMethod ].

	process shiftLevelUp.
	handler
		beforeExecutionWithReceiver: aReceiver
		arguments: anArrayOfObjects.
	process shiftLevelDown.
	unwinder := MpInstrumentationUnwinder
		            newWithHandler: handler
		            receiver: aReceiver
		            arguments: anArrayOfObjects.
	[
	result := self
		          receiver: aReceiver
		          withArgs: anArrayOfObjects
		          executeMethod: proxifiedMethod ] ensure: unwinder.

	process shiftLevelUp.
	unwinder executed ifNil: [
		handler
			aboutToReturnWithReceiver: aReceiver
			arguments: anArrayOfObjects ].
	result := handler
		          afterExecutionWithReceiver: aReceiver
		          arguments: anArrayOfObjects
		          returnValue: result.
	process shiftLevelDown.
	^ result
]

{ #category : #accessing }
PrfMethodProxy >> runner [

	^ runner
]

{ #category : #accessing }
PrfMethodProxy >> runner: anObject [

	runner := anObject
]

{ #category : #accessing }
PrfMethodProxy >> selector [

	^ selector
]

{ #category : #accessing }
PrfMethodProxy >> selector: aSymbol [

	selector := aSymbol
]

{ #category : #installation }
PrfMethodProxy >> shouldWrap: aMethod [

	(aMethod isCompiledMethod not and: [
		 aMethod handler class ~~ self handler class ]) ifTrue: [ ^ true ].

	aMethod isCompiledMethod ifFalse: [ ^ false ].

	^ aMethod pragmas noneSatisfy: [ :pragma |
		  pragma selector = #methodProxyCannotWrap or: [
			  pragma selector = #noInstrumentation ] ]
]

{ #category : #installation }
PrfMethodProxy >> uninstall [

	| installedMethod |
	thisProcess runInMetaLevel: [
		installedMethod := methodClass
			                   compiledMethodAt: selector
			                   ifAbsent: [ ^ self ].
		installedMethod == self ifTrue: [
			methodClass methodDict
				at: selector
				put: installedMethod wrappedMethod ].
		self unproxifiedMethod: nil ]
]

{ #category : #accessing }
PrfMethodProxy >> unproxifiedMethod [
	"The unproxifedMethod returns the proxified method even in case we have multiple proxified nesting."
	
	^ proxifiedMethod ifNotNil: [ proxifiedMethod unproxifiedMethod ]
]

{ #category : #'when installed' }
PrfMethodProxy >> unproxifiedMethod: aCompiledMethod [

	proxifiedMethod := aCompiledMethod
]

{ #category : #evaluating }
PrfMethodProxy >> valueWithReceiver: receiver arguments: arguments [

	<methodProxyCannotWrap>
	| result |
	"Hooking into user methods to define before actions.
	Before actions are not instrumented."
	thisProcess runInMetaLevel: [
		handler beforeExecutionWithReceiver: receiver arguments: arguments ].

	"Purposely do not use a non-local return.
	Otherwise the non-local return logic would be instrumented and this could end in infinite loops"
	[
	result := self
		          receiver: receiver
		          withArgs: arguments
		          executeMethod: proxifiedMethod ] methodProxyEnsure:
		(MpInstrumentationUnwinder
			 newWithHandler: handler
			 receiver: receiver
			 arguments: arguments).

	thisProcess runInMetaLevel: [^ handler
		  afterExecutionWithReceiver: receiver
		  arguments: arguments
		  returnValue: result]
]

{ #category : #accessing }
PrfMethodProxy >> wrappedClass [

	^ methodClass
]

{ #category : #accessing }
PrfMethodProxy >> wrappedClass: aClass [

	methodClass := aClass
]

{ #category : #'when installed' }
PrfMethodProxy >> wrappedMethod [

	^ proxifiedMethod
]
