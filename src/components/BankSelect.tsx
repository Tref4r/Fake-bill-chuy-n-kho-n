import React, { useEffect, useState } from 'react';

const BankSelect = ({ value, onChange }) => {
  const [banks, setBanks] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetch(process.env.REACT_APP_BANK_API || '/api/banks')
      .then(res => res.json())
      .then(data => {
        setBanks(data);
        setLoading(false);
      })
      .catch(() => {
        setBanks([]);
        setLoading(false);
      });
  }, []);

  return (
    <select value={value} onChange={onChange} required>
      <option value="">Chọn ngân hàng</option>
      {banks.map(bank => (
        <option key={bank.code} value={bank.code}>{bank.name}</option>
      ))}
    </select>
  );
};

export default BankSelect;