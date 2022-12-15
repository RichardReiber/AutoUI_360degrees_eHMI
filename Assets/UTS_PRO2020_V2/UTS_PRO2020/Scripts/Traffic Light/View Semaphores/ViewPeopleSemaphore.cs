using System;

public class ViewPeopleSemaphore : TLGraphicsControl
{
    public event Action<bool> OnPeopleGreenChanged;

    public override void ChangeGreen(bool greenState)
    {
        base.ChangeGreen(greenState);
        
        OnPeopleGreenChanged?.Invoke(greenState);
    }
}