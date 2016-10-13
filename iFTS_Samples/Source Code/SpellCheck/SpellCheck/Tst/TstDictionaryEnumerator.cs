using System;
using System.Collections;

namespace Tst
{
	
	public sealed class TstDictionaryEnumerator : IDictionaryEnumerator
	{
		private long version;
		private Stack stack;
		private TstDictionaryEntry currentNode;
		private TstDictionary dictionary;
	
		public TstDictionaryEnumerator(TstDictionary tst)
		{
			if (tst==null)
				throw new ArgumentNullException("tst");
			this.version = tst.Version;
			this.dictionary = tst;
			this.currentNode = null;
			this.stack = null;
		}

		public void Reset()
		{
			this.ThrowIfChanged();
			this.stack.Clear();
			stack=null;
		}
	     
	
		public DictionaryEntry Current
		{
			get
			{
				this.ThrowIfChanged();
				return this.Entry;
			}
		}
	
		Object IEnumerator.Current
		{
			get
			{
				return this.Current;
			}
		}
	
		public DictionaryEntry Entry
		{
			get
			{
				this.ThrowIfChanged();
				if (currentNode==null)
					throw new InvalidOperationException();
				return new DictionaryEntry(currentNode.Key,currentNode.Value);			
			}
		}
	
		public String Key
		{
			get
			{
				this.ThrowIfChanged();
				if (currentNode==null)
					throw new InvalidOperationException();
				return currentNode.Key;
			}
		}
	
		Object IDictionaryEnumerator.Key
		{
			get
			{
				return this.Key;			
			}
		}
	
		public Object Value
		{
			get
			{
				this.ThrowIfChanged();
				if (currentNode==null)
					throw new InvalidOperationException();
				return currentNode.Value;
			}
		}
		
		public bool MoveNext()
		{
			this.ThrowIfChanged();

			// we are at the beginning
			if (stack==null)
			{
				stack=new Stack();
				currentNode=null;
				if (dictionary.Root!=null) 	
					stack.Push(dictionary.Root);
			}
			// we are at the end node, finished
			else if (currentNode==null)
				throw new InvalidOperationException("out of range");
			
			if (stack.Count==0)
				currentNode=null;
			
			while (stack.Count > 0)
			{				
				currentNode = (TstDictionaryEntry)stack.Pop();				
				if (currentNode.HighChild!=null)
					stack.Push(currentNode.HighChild);
				if (currentNode.EqChild!=null)
					stack.Push(currentNode.EqChild);
				if (currentNode.LowChild!=null)
					stack.Push(currentNode.LowChild);			
				
				if (currentNode.IsKey)
					break;
			}
					
			return currentNode != null;
		}                               	
		
		internal void ThrowIfChanged()
		{
			if (version != dictionary.Version)
				throw new InvalidOperationException("Collection changed");
		}
	
	}
}
