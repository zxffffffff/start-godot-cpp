using Godot;
using System;
using static Godot.GD;

public partial class new_csharp : Node
{
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		Print("C# is ready!");
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
	}
}
