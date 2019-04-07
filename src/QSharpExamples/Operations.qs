namespace QSharpExamples
{
	open Microsoft.Quantum.Primitive;
	open Microsoft.Quantum.Canon;
	
	operation Set (desired: Result, q1: Qubit) : Unit {
		let current = M(q1);

		if (desired != current)
		{
			X(q1);
		}
	}
	
	operation Reset(q: Qubit) : (Unit)
	{
		if (M(q) == One)
		{
			X(q);
		}
	}
	
	operation ForEach(qubits: Qubit[], action: (Qubit => Unit)) : (Unit)
	{
		for (qubit in qubits)
		{
			action(qubit);
		}
	}

	operation ReversableGate(initial: Result) : Result
	{
		mutable result = Zero;

		using (qubit = Qubit())
		{
			Set(initial, qubit);
			H(qubit);
			H(qubit);
			
			set result = M(qubit);
			Reset(qubit);
		}
		
		return result;
	}

	operation MeasurementCollapsingSuperposition(initial: Result) : (Result, Result)
	{
		mutable result = Zero;
		mutable result2 = Zero;

		using (qubit = Qubit())
		{
			Set(initial, qubit);
			H(qubit);
			set result = M(qubit);
			H(qubit);
			set result2 = M(qubit);

			Reset(qubit);
		}
		
		return (result, result2);
	}
	
	operation GenerateRandomNumber () : (Int)
	{
		mutable number = 0;
		using (qubit = Qubit())
		{
			for (i in 0..7)
			{
				H(qubit);
			
				let res = M (qubit);

				if (res == One)
				{
					set number = number + 2^i;
				}
			}

			Set(Zero, qubit);
		}

		return number;
	}

	operation BellTest (count: Int, initial: Result) : (Int, Int, Int)
	{
		mutable numOnes = 0;
		mutable agree = 0;

		using (qubits = Qubit[2])
		{
			for (test in 1..count)
			{
				Set(initial, qubits[0]);
				Set(Zero, qubits[1]);
				H(qubits[0]);
				CNOT(qubits[0],qubits[1]);
				
				let res = M (qubits[0]);

				if (M(qubits[1]) == res)
				{
					set agree = agree + 1;
				}

				if (res == One)
				{
					set numOnes = numOnes + 1;
				}
			}

			Set(Zero, qubits[0]);
			Set(Zero, qubits[1]);
		}

		return (count-numOnes, numOnes, agree);
	}

	//Deutsch-Jozsa
	operation Constant0() : (Result, Result, Bool)
	{
		mutable wasConstant = false;
		mutable outputResult = One;
		mutable inputResult = One;

		using (qubits = Qubit[2])
		{
			let output = qubits[0];
			let input = qubits[1];

			Set(Zero, output);
			Set(Zero, input);

			X(output);
			X(input);

			H(output);
			H(input);

			// Do nothing

			H(output);
			H(input);

			set outputResult = M(output);
			set inputResult = M(input);

			if (outputResult == One)
			{
				set wasConstant = true;
			}

			ForEach(qubits, Reset);
		}
		
		return (outputResult, inputResult, wasConstant);
	}

	//Deutsch-Jozsa
	operation Constant1() : (Result, Result, Bool)
	{
		mutable wasConstant = false;
		mutable outputResult = One;
		mutable inputResult = One;

		using (qubits = Qubit[2])
		{
			let output = qubits[0];
			let input = qubits[1];

			Set(Zero, output);
			Set(Zero, input);

			X(output);
			X(input);

			H(output);
			H(input);

			// Negate output
			X(output);

			H(output);
			H(input);

			set outputResult = M(output);
			set inputResult = M(input);

			if (outputResult == One)
			{
				set wasConstant = true;
			}

			ForEach(qubits, Reset);
		}
		
		return (outputResult, inputResult, wasConstant);
	}

	//Deutsch-Jozsa
	operation Identity() : (Result, Result, Bool)
	{
		mutable wasConstant = false;
		mutable outputResult = One;
		mutable inputResult = One;

		using (qubits = Qubit[2])
		{
			let output = qubits[0];
			let input = qubits[1];

			Set(Zero, output);
			Set(Zero, input);

			X(output);
			X(input);

			H(output);
			H(input);

			// XOR
			CNOT(output, input);

			H(output);
			H(input);

			set outputResult = M(output);
			set inputResult = M(input);

			if (outputResult == One)
			{
				set wasConstant = true;
			}

			ForEach(qubits, Reset);
		}
		
		return (outputResult, inputResult, wasConstant);
	}

	//Deutsch-Jozsa
	operation Negation() : (Result, Result, Bool)
	{
		mutable wasConstant = false;
		mutable outputResult = One;
		mutable inputResult = One;

		using (qubits = Qubit[2])
		{
			let output = qubits[0];
			let input = qubits[1];

			Set(Zero, output);
			Set(Zero, input);

			X(output);
			X(input);

			H(output);
			H(input);

			//Negate XOR
			CNOT(output, input);
			X(output);

			H(output);
			H(input);

			set outputResult = M(output);
			set inputResult = M(input);

			if (outputResult == One)
			{
				set wasConstant = true;
			}

			ForEach(qubits, Reset);
		}
		
		return (outputResult, inputResult, wasConstant);
	}

	operation DeutschJozsa(func: ((Qubit, Qubit) => Unit)): (Result, Result, Bool)
	{
		mutable wasConstant = false;
		mutable outputResult = One;
		mutable inputResult = One;

		using (qubits = Qubit[2])
		{
			let output = qubits[0];
			let input = qubits[1];

			Set(Zero, output);
			Set(Zero, input);

			X(output);
			X(input);

			H(output);
			H(input);

			func(output, input);

			H(output);
			H(input);

			set outputResult = M(output);
			set inputResult = M(input);

			if (outputResult == One)
			{
				set wasConstant = true;
			}

			ForEach(qubits, Reset);
		}
		
		return (outputResult, inputResult, wasConstant);
	}

	operation SendMessage(message: Bool) : (Bool)
	{
		mutable measurement = false;

		using (qubits = Qubit[2])
		{
			let msg = qubits[0];
			let there = qubits[1];
			
			if (message)
			{
				X(msg);
			}

			Teleport(msg, there);
			
			if (M(there) == One)
			{
				set measurement = true;
			}

			ForEach(qubits, Reset);
		}

		return measurement;
	}

	operation Teleport(msg: Qubit, there: Qubit) : Unit
	{
		using (here = Qubit())
		{
			//Make superposition of here and there
			H(here);
			CNOT(here, there);

			//Move message to here
			CNOT(msg, here);
			H(msg);
			
			//"Indirect" measurement 
			if (M(msg) == One)
			{
				Z(there);
			}

			if (M(here) == One)
			{
				X(there);
			}

			Reset(here);
		}
	}
}
