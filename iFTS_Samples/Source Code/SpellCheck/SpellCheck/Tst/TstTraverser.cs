using System;
using System.Collections;

namespace Tst
{
    public class TstTraverser
	{
		public TstTraverser()
		{}

		public void Traverse(TstDictionary dic)
		{
			if (dic==null)
				throw new ArgumentNullException("dic");
			Traverse(dic.Root);
		}

		public event TstDictionaryEntryEventHandler TreeEntry;
		
		protected virtual void OnTreeEntry(TstDictionaryEntry p)
		{
			if (TreeEntry!=null)
				TreeEntry(this,
					new TstDictionaryEntryEventArgs(p)
					);
		}

		public event TstDictionaryEntryEventHandler LowChild;
		
		protected virtual void OnLowChild(TstDictionaryEntry p)
		{
			if (LowChild!=null)
				LowChild(this,
					new TstDictionaryEntryEventArgs(p)
					);
		}
		
		public event TstDictionaryEntryEventHandler EqChild;
		
		protected virtual void OnEqChild(TstDictionaryEntry p)
		{
			if (EqChild!=null)
				EqChild(this,
					new TstDictionaryEntryEventArgs(p)
					);
		}

		public event TstDictionaryEntryEventHandler HighChild;
		
		protected virtual void OnHighChild(TstDictionaryEntry p)
		{
			if (HighChild!=null)
				HighChild(this,
					new TstDictionaryEntryEventArgs(p)
					);
		}

		protected void Traverse(TstDictionaryEntry p)
		{
			if (p==null)
				return;

			OnTreeEntry(p);

			OnLowChild(p.LowChild);
			Traverse(p.LowChild);
			OnEqChild(p.EqChild);
			Traverse(p.EqChild);
			OnHighChild(p.HighChild);
			Traverse(p.HighChild);
		}
		
 	}
}
