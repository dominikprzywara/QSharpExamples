using System;

using Microsoft.Quantum.Simulation.Core;
using Microsoft.Quantum.Simulation.Simulators;

namespace QSharpExamples
{
    class Driver
    {
        static void Main(string[] args)
        {
            void PressKey(string name)
            {
                Console.WriteLine($"\n\nPress any key to start {name}\n\n");
                Console.ReadKey();
            }

            using (var qsim = new QuantumSimulator())
            {
                PressKey("Reversable gate");

                for (int i = 0; i < 5; ++i)
                {
                    var initialValue = i % 2 == 0 ? Result.Zero : Result.One;
                    var result = ReversableGate.Run(qsim, initialValue).Result;
                    Console.WriteLine($"Reversable gate result is: " +
                        $"{result}. Initial value: {initialValue}");
                }

                PressKey("Measurement superposition collapsing");

                for (int i = 0; i < 15; ++i)
                {
                    var initialValue = i % 2 == 0 ? Result.One : Result.Zero;
                    var result = MeasurementCollapsingSuperposition
                        .Run(qsim, initialValue).Result;
                    Console.WriteLine(
                        $"Reversable gate result is: {result.Item1}. " +
                        $"Result2: {result.Item2}. Inital value: {initialValue}");
                }

                PressKey("Random number generator");

                for (int i = 0; i < 10; ++i)
                {
                    var randomNumber = GenerateRandomNumber.Run(qsim).Result;
                    Console.WriteLine($"Random number is: {randomNumber}");
                }

                PressKey("Bell test");

                Result[] initials = new Result[] { Result.Zero, Result.One };
                foreach (var initial in initials)
                {
                    var res = BellTest.Run(qsim, 1000, initial).Result;

                    var (numZeros, numOnes, agrees) = res;
                    Console.WriteLine($"" +
                        $"Init:{initial,-4} " +
                        $"0s={numZeros,-4} " +
                        $"1s={numOnes,-4} " +
                        $"Agrees = {agrees,-4}");
                }

                PressKey("Deutsch-Jozsa");

                var const0Result = Constant0.Run(qsim).Result;
                var const1Result = Constant1.Run(qsim).Result;
                var negationResult = Negation.Run(qsim).Result;
                var identityResult = Identity.Run(qsim).Result;

                Console.WriteLine($"Const0: " +
                    $"{const0Result.Item1} " +
                    $"{const0Result.Item2} " +
                    $"{const0Result.Item3}");

                Console.WriteLine($"Const1: " +
                    $"{const1Result.Item1} " +
                    $"{const1Result.Item2} " +
                    $"{const1Result.Item3}");

                Console.WriteLine($"Identity: " +
                    $"{identityResult.Item1} " +
                    $"{identityResult.Item2} " +
                    $"{identityResult.Item3}");

                Console.WriteLine($"Negation: " +
                    $"{negationResult.Item1} " +
                    $"{negationResult.Item2} " +
                    $"{negationResult.Item3}");

                PressKey("Teleportation part 1");

                for (int i = 0; i < 5; ++i)
                {
                    Console.WriteLine($"Teleport (msg==false): " +
                        $"{SendMessage.Run(qsim, false).Result}");
                }

                PressKey("Teleportation part 2");

                for (int i = 0; i < 5; ++i)
                {
                    Console.WriteLine($"Teleport (msg==true): " +
                        $"{SendMessage.Run(qsim, true).Result}");
                }
            }

            Console.WriteLine("\n\nEnd");
            Console.ReadKey();
        }
    }
}
